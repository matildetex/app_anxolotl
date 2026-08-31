import 'dart:async';

import 'package:anxolotl_app/src/data/data_acces/repositories/secure_storage_repository.dart';
import 'package:anxolotl_app/src/data/model/user/user_profile.dart';
import 'package:anxolotl_app/src/data/services/foreground_operations/foreground_operation_name.dart';
import 'package:anxolotl_app/src/data/services/foreground_operations/operations/iforeground_operation.dart';
import 'package:anxolotl_app/src/data/services/foreground_operations/operations/measurement_background_operation.dart';
import 'package:anxolotl_app/src/lang/anxolotl_localizations.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ForegroundOperationsService {
  static final FlutterBackgroundService _service = FlutterBackgroundService();
  final SecureStorageRepository _secureStorageRepository;
  ForegroundOperation? foregroundOperationName;
  int _batteryLevel = -1;

  late final Map<String, String> translatedLanguageArgs = {};

  ForegroundOperationsService(this._secureStorageRepository) {
    _service.on(ForegroundOperationsArguments.BATTERY_RESP_ARG).listen((event) {
      if (event != null) {
        _batteryLevel =
            event[ForegroundOperationsArguments.BATTERY_RESP_MAP_ARG];
      }
    });

    _service
        .on(ForegroundOperationsArguments.RESTART_NOTIFICATION)
        .listen((event) async {
      await stopForegroundTask();
      final MeasurementBackgroundOperation dmbo =
          MeasurementBackgroundOperation();
      startForegroundTask(dmbo);
    });
  }

  Future<ForegroundOperationsService> init() async {
    await loadStrings();
    return this;
  }

  Future<void> loadStrings() async {
    if (translatedLanguageArgs.isEmpty) {
      AnxolotlLocalizations localizations =
          await LocalizationsUtil.l10nContextless();

      translatedLanguageArgs.addAll({
        LangArgs.PREPARING: localizations.preparingMeasure,
        LangArgs.ERROR_FOUND: localizations.errorWord,
        LangArgs.MEASURES: localizations.measureWord,
        LangArgs.SYNC: localizations.syncWord,
        LangArgs.LAST_MEASUREMENT: localizations.lastMeasurement,
        LangArgs.SYNCING: localizations.syncingExpression,
        LangArgs.DEVICE_NOT_CONNECTED: localizations.connectDeviceNotPossible,
        LangArgs.INTERNET_NOT_CONNECTED:
            localizations.notConnectedToTheInternet,
      });
      print("#####FILLING STRINGS");
    }
  }

  Future<void> startForegroundTask(
      ForegroundOperation foregroundOperationName) async {
    print("##### Starting foregorund");

    foregroundOperationName.startForegroundTask(_service).then((value) async {
      // THIS time is needed so the configurations can be passed
      await Future.delayed(const Duration(seconds: 4));

      _service.invoke(ForegroundOperationsArguments.AMQP_CONFIGS_ARG, {
        ForegroundOperationsArguments.AMQP_CONFIGS_HOST_ARG:
            dotenv.env["RABBITMQ_HOST_ADDRESS"] ?? "localhost",
        ForegroundOperationsArguments.AMQP_CONFIGS_PORT_ARG:
            dotenv.env["RABBITMQ_HOST_PORT"] ?? "5671",
      });

      _service.invoke(ForegroundOperationsArguments.TRANSLATED_STR_ARG,
          translatedLanguageArgs);

      _service.invoke(ForegroundOperationsArguments.AUTHPROFILE_ARG, {
        ForegroundOperationsArguments.AUTHPROFILE_MAP_ARG:
            (await _secureStorageRepository.readSerialized<AuthProfile>())!
                .serialize()
      });

      _service.invoke(ForegroundOperationsArguments.WORK_CONFIGS_ARG, {
        ForegroundOperationsArguments.WORK_SAMPLING_INTERVAL_ARG:
            int.parse(dotenv.env["WORK_RECONNECT_INTERVAL"] ?? "30"),
        ForegroundOperationsArguments.WORK_SYNC_INTERVAL_ARG:
            int.parse(dotenv.env["UPLOAD_WORK_INTERVAL"] ?? "30"),
      });
    });
  }

  // to ensure this executed
// run app from xcode, then from xcode menu, select Simulate Background Fetch
  Future<void> stopForegroundTask() async {
    _service.invoke(ForegroundOperationsArguments.STOP_ARG);
    return Future.delayed(const Duration(milliseconds: 1500));
  }

  int getBatteryLevel() => _batteryLevel;

  Future<bool> isRunning() => _service.isRunning();
}
