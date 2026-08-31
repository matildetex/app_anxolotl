import 'dart:async';
import 'dart:ui';

import 'package:anxolotl_app/src/data/model/entities/measurements/implementations/measurement.dart';
import 'package:anxolotl_app/src/data/model/user/user_profile.dart';
import 'package:anxolotl_app/src/data/services/bluetooth/bluetooth_dev.dart';
import 'package:anxolotl_app/src/data/services/device/device_service.dart';
import 'package:anxolotl_app/src/data/services/foreground_operations/foreground_operation_name.dart';
import 'package:anxolotl_app/src/data/services/foreground_operations/operations/iforeground_operation.dart';
import 'package:anxolotl_app/src/data/services/foreground_operations/operations/tokens.dart';
import 'package:anxolotl_app/src/data/services/services_aggregator/device_services_aggregator.dart';
import 'package:anxolotl_app/src/data/utils/network_validator.dart';
import 'package:anxolotl_app/src/lang/anxolotl_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:path_provider/path_provider.dart';

class MeasurementBackgroundOperation extends ForegroundOperation {
  static const notificationChannelName = "Anxolotl App";
  static const notificationChannelId = "anxolotl_working_notification_id";
  static const notificationId = 112233;

  @override
  Future<void> startForegroundTask(FlutterBackgroundService service,
      [String? preparingString]) async {

    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      notificationChannelId, // id
      notificationChannelName, // title
      importance: Importance.low, // importance must be at low or higher level
    );

    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    await service.configure(
      androidConfiguration: AndroidConfiguration(
        // this will executed when app is in foreground or background in separated isolate
        onStart: onStartMeasurement,
        notificationChannelId: notificationChannelId,
        foregroundServiceNotificationId: notificationId,
        isForegroundMode: true,
        autoStart: true,
        initialNotificationTitle: notificationChannelName,
        initialNotificationContent: preparingString ?? "",
      ),
      iosConfiguration: IosConfiguration(
          // this will executed when app is in foreground in separated isolate
          onForeground: onStartMeasurement,

          // you have to enable background fetch capability on xcode project
          onBackground: onIosBackgroundDiscreteMeasurement,
          autoStart: true),
    );
  }

  static Future<void> _updateNotification(String bodyContent) async {
    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();

    flutterLocalNotificationsPlugin.show(
      notificationId,
      notificationChannelName,
      bodyContent,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          notificationChannelId,
          notificationChannelName,
          icon: 'ic_bg_service_small',
          ongoing: true,
        ),
      ),
    );
  }
}

Future<bool> onIosBackgroundDiscreteMeasurement(
    ServiceInstance instance) async {
  onStartMeasurement(instance);
  return true;
}

@pragma('vm:entry-point')
void onStartMeasurement(ServiceInstance service) async {
  //Values

  late DeviceServicesAggregator deviceServicesAggregator =
      DeviceServicesAggregator.blank();
  final String dbPath =
      await getApplicationSupportDirectory().then((value) => value.path);

  late BluetoothDev? bluetoothDev;
  await deviceServicesAggregator.fullInit("$dbPath/measurements");

  Duration workSamplingTime = const Duration(seconds: 30);
  Duration syncWorkInterval = const Duration(minutes: 30);

  MeasuringMode currentMeasuringMode = MeasuringMode.DISCRETE;

  CancellationToken cancellationToken = CancellationToken();

  late AuthProfile? authProfile;

  final Map<String, String> translatedLanguageArgs = <String, String>{};

  ///////////////////////////

  service.on(ForegroundOperationsArguments.TRANSLATED_STR_ARG).listen((event) {
    print("##### Translated Strings");
    if (event != null) {
      print(event.values.first);
      event.forEach((String key, dynamic value) {
        translatedLanguageArgs[key] = value as String;
      });
    }
  });

  service.on(ForegroundOperationsArguments.AUTHPROFILE_ARG).listen((event) {
    print("#######0");
    if (event != null) {
      authProfile = AuthProfileFactory().newInstance(
          event[ForegroundOperationsArguments.AUTHPROFILE_MAP_ARG] as String);
    }
  });

  /**
   * Stopping service callback
   */
  service.on(ForegroundOperationsArguments.STOP_ARG).listen((event) async {
    print("#######1");
    cancellationToken.isCancelled = true;
    service.invoke(ForegroundOperationsArguments.BATTERY_RESP_ARG,
        {ForegroundOperationsArguments.BATTERY_RESP_MAP_ARG: -1});
    await deviceServicesAggregator.disconnectDevice();
    service.stopSelf();
    return;
  });

  service
      .on(ForegroundOperationsArguments.AMQP_CONFIGS_ARG)
      .listen((event) async {
    print("#######3");
    if (event != null) {
      deviceServicesAggregator.connectAmqp(
          event[ForegroundOperationsArguments.AMQP_CONFIGS_HOST_ARG],
          event[ForegroundOperationsArguments.AMQP_CONFIGS_PORT_ARG]);
    }
  });

  /**
   * Changing device measurement parameters callback
   */
  service
      .on(ForegroundOperationsArguments.WORK_CONFIGS_ARG)
      .listen((event) async {
    if (event != null) {
      print("#######2");

      syncWorkInterval = Duration(
          minutes: event[ForegroundOperationsArguments.WORK_SYNC_INTERVAL_ARG]);

      workSamplingTime = Duration(
          seconds:
              event[ForegroundOperationsArguments.WORK_SAMPLING_INTERVAL_ARG]);

      if (workSamplingTime.inSeconds > 5) {
        currentMeasuringMode = MeasuringMode.DISCRETE;
      } else {
        currentMeasuringMode = MeasuringMode.CONTINUOUS;
        //Since this forces a new connection to the band, and continuous mode, just uses a connection
        // for this duration. While discrete mode needs to start a connection everytime it wants to measure.
        workSamplingTime = const Duration(minutes: 10);
      }
    }
  });
  /***
   * Service to get updated language strings
   */

  /*****************************************
   * Starting work preparations
   *****************************************/

  // THIS time is needed so the configurations can be passed
  await Future.delayed(const Duration(seconds: 10));

  DartPluginRegistrant.ensureInitialized();
  WidgetsFlutterBinding.ensureInitialized();

  bluetoothDev = await deviceServicesAggregator.loadDevice();
  await deviceServicesAggregator.connectToDevice(bluetoothDev);
  // bring to foreground

  if (currentMeasuringMode == MeasuringMode.CONTINUOUS) {
    workFunction(authProfile!.id, bluetoothDev, deviceServicesAggregator,
        currentMeasuringMode, workSamplingTime, cancellationToken);
  }

  /***
   * Work function
   */
  Timer.periodic(workSamplingTime, (timer) async {
    await deviceServicesAggregator.reloadStorage();
    if ((await deviceServicesAggregator.loadDevice()) == null) {
      cancellationToken.isCancelled = true;
      service.invoke(ForegroundOperationsArguments.BATTERY_RESP_ARG,
          {ForegroundOperationsArguments.BATTERY_RESP_MAP_ARG: -1});
      await deviceServicesAggregator.disconnectDevice();
      service.stopSelf();
      print("####### NOT Found");
      return;
    } else if (!deviceServicesAggregator.isDeviceConnected()) {
      BluetoothDev bluetoothDev =
          (await deviceServicesAggregator.loadDevice())!;
      await deviceServicesAggregator.connectToDevice(bluetoothDev);
    }
    print("####### Device Found");

    String measurementStr = "";
    try {
      if (!deviceServicesAggregator.isDeviceConnected()) {
        throw Exception(translatedLanguageArgs[LangArgs.DEVICE_NOT_CONNECTED]!);
      }
      await Future.any([
        workFunction(authProfile!.id, bluetoothDev, deviceServicesAggregator,
            currentMeasuringMode, workSamplingTime, cancellationToken),
        Future.delayed(Duration(seconds: workSamplingTime.inSeconds * 3))
      ]);

      measurementStr = translatedLanguageArgs[LangArgs.LAST_MEASUREMENT]! +
          LocalizationsUtil.timeFormatString(DateTime.now());
    } catch (exception) {
      print("ERROR : ${exception.toString()}");
      String exceptionStr = "???";
      if (exception is Exception) {
        exceptionStr = exception.toString();
      } else {
        measurementStr =
            "${translatedLanguageArgs[LangArgs.MEASURES]} ${translatedLanguageArgs[LangArgs.ERROR_FOUND]} : $exceptionStr";
      }
      await deviceServicesAggregator.disconnectDevice();
    } finally {
      MeasurementBackgroundOperation._updateNotification(measurementStr);
    }
  });

  /***
   * Synchronization function
   */
  Timer.periodic(syncWorkInterval, (timer) async {
    //if (!(await service.isRunning())) timer.cancel();
    String resultStr = translatedLanguageArgs[LangArgs.SYNCING]!;
    try {
      //Checking Internet connection
      if (await NetworkValidator().isNetworkConnected()) {
        await deviceServicesAggregator.syncMeasurements(
            bluetoothDev!.getIdentifier(), authProfile!, workSamplingTime);
      } else {
        throw Exception(
            translatedLanguageArgs[LangArgs.INTERNET_NOT_CONNECTED]!);
      }
    } catch (exception) {
      String exceptionStr = "???";
      if (exception is Exception) {
        exceptionStr = exception.toString();
      } else {
        resultStr =
            "${translatedLanguageArgs[LangArgs.SYNC]} ${translatedLanguageArgs[LangArgs.ERROR_FOUND]} : $exceptionStr";
      }
    } finally {
      MeasurementBackgroundOperation._updateNotification(resultStr);
    }
  });

  /***
   * Restart function
   */
  Timer.periodic(const Duration(minutes: 120), (timer) async {
    service.invoke(ForegroundOperationsArguments.RESTART_NOTIFICATION);
  });
}

Future<void> workFunction(
    String userId,
    BluetoothDev? bluetoothDev,
    DeviceServicesAggregator deviceServicesAggregator,
    MeasuringMode measuringMode,
    Duration workSamplingTime,
    CancellationToken cancellationToken) async {
  Measurement configSettings;
  switch (measuringMode) {
    case MeasuringMode.DISCRETE:
      configSettings = Measurement.Discrete();
      await deviceServicesAggregator.configureDevice(measuringMode);
      break;
    case MeasuringMode.CONTINUOUS:
      configSettings = Measurement.Continuous(
          durationOfMeasurement: Duration(seconds: workSamplingTime.inSeconds));
      await deviceServicesAggregator.configureDevice(measuringMode);

      break;
  }

  await deviceServicesAggregator.startMultiMeasurement(
      userId,
      measuringMode,
      deviceServicesAggregator.getDeviceSensors(),
      configSettings,
      cancellationToken);

  print("Finished starting notification");
}
