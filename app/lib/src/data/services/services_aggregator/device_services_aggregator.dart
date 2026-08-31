import 'package:anxolotl_app/src/data/data_acces/api/amqp/amqp_api.dart';
import 'package:anxolotl_app/src/data/data_acces/database/object_box_db.dart';
import 'package:anxolotl_app/src/data/data_acces/repositories/implementation/measurement_repository.dart';
import 'package:anxolotl_app/src/data/data_acces/repositories/implementation/user_info_repository.dart';
import 'package:anxolotl_app/src/data/data_acces/repositories/shared_preferences_repository.dart';
import 'package:anxolotl_app/src/data/model/entities/common/sensor/sensor.dart';
import 'package:anxolotl_app/src/data/model/entities/measurements/implementations/measurement.dart';
import 'package:anxolotl_app/src/data/model/entities/measurements/implementations/measurement_state.dart';
import 'package:anxolotl_app/src/data/model/user/user_profile.dart';
import 'package:anxolotl_app/src/data/services/bluetooth/bluetooth_dev.dart';
import 'package:anxolotl_app/src/data/services/device/contracts/acquisition_objects.dart';
import 'package:anxolotl_app/src/data/services/device/device_service.dart';
import 'package:anxolotl_app/src/data/services/foreground_operations/operations/tokens.dart';
import 'package:anxolotl_app/src/data/services/measurement/measurement_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:anxolotl_app/src/data/services/health/watch_streaming_service.dart';

class DeviceServicesAggregator {
  late final DeviceService _deviceService;
  late final MeasurementService _measurementService;
  late final AmqpApi amqpApi;

  DeviceServicesAggregator(this._deviceService, this._measurementService);

  DeviceServicesAggregator.blank();

  WatchStreamingService? _watchStreamingService;

  Future<void> initWatch() async {
    _watchStreamingService = WatchStreamingService();
    await _watchStreamingService!.init();

    _watchStreamingService!.dataStream.listen((watchData) {
      if (watchData.hr != null) {
        print("Watch HR: ${watchData.hr} bpm");
      }
      if (watchData.ibi != null) {
        print("Watch IBI: ${watchData.ibi} ms");
      }
      if (watchData.steps != null) {
        print("Watch Steps: ${watchData.steps}");
      }
      if (watchData.calories != null) {
        print("Watch Calories: ${watchData.calories} kcal");
      }
      if (watchData.distance != null) {
        print("Watch Distance: ${watchData.distance} m");
      }
    });
  }

  WatchStreamingService? get watchStreamingService => _watchStreamingService;

  void disposeWatch() {
    _watchStreamingService?.dispose();
  }

  Future<void> fullInit(String path) async {
    amqpApi = AmqpApi();

    await ObjectBoxDb().init(path: path);
    _measurementService =
        MeasurementService(MeasurementRepository(amqpApi));
    _deviceService = DeviceService(
        SharedPreferencesRepository(await SharedPreferences.getInstance()),
        UserInfoRepository(amqpApi));
  }

  Future<void> connectAmqp(String host, String port) async {
    await amqpApi.initClient(host, port);
  }

  Future<bool> connectToDevice(BluetoothDev? bluetoothDev) async {
    if (bluetoothDev == null) return false;
    return await _deviceService.connectToDevice(bluetoothDev);
  }

  Future<bool> disconnectDevice() async {
    return await _deviceService.disconnectDevice(removeFromMemory: false);
  }

  bool isDeviceConnected() => _deviceService.isDeviceConnected();

  Iterable<Sensor> getDeviceSensors() => _deviceService.getDeviceSensors();

  Future<void> configureDevice(MeasuringMode measuringMode,
          {Duration? samplingRate}) =>
      _deviceService.configureDevice(measuringMode, samplingRate: samplingRate);

  Future<Map<Sensor, String>> startMultiMeasurement(
      String userId,
      MeasuringMode measuringMode,
      Iterable<Sensor> sensors,
      Measurement measurementSettings,
      CancellationToken cancellationToken) async {
    Map<Sensor, String> measurementIds = {};

    print("### STARTING MULTI MEASUREMENT");

    Iterable<AcquisitionStream> sensorAcqStreamList =
        await _deviceService.startMultiAcquisition(sensors);
    await Future.wait(
        sensorAcqStreamList.map((AcquisitionStream sensorAcqStream) async {
      //NEW test - watch out for logic
      String newMeasurementId = _measurementService.createNew(
          currSensor: sensorAcqStream.sensor,
          configMeasurement: measurementSettings);

      /**
           * PROCESSING THE DATA IN THE LINE BELOW
           */

      await _measurementService.startMeasuring(
          newMeasurementId,
          sensorAcqStream.getStream().where((AcquisitionReturn returnVal) =>
              sensorAcqStream.sensor.filterValues(returnVal.values)),
          cancellationToken);
      //sensorAcqStream.getStream(), cancellationToken);

      sensorAcqStream.receiverStream.listen((event) async {
        if (cancellationToken.isCancelled ||
            (_measurementService.containsMeasurement(newMeasurementId) &&
                _measurementService
                        .getMeasurement(newMeasurementId)
                        .getState() ==
                    MeasurementState.FINISHED)) {
          sensorAcqStream.pause();
          await stopMeasurement(userId, newMeasurementId);
        }
      });

      /*if(measuringMode == MeasuringMode.DISCRETE){
            /**
             * Discrete mode sometimes takes too long to stop the measurement, leading t
             * delays, which might be crucial not to happen. This if avoids must delays
             */
            await stopMeasurement(newMeasurementId);   priority: Priority.high,
            sensorAcqStream.pause();
          }*/

      measurementIds[sensorAcqStream.sensor] = newMeasurementId;
    }));
    return measurementIds;
  } //TODO passar isto para streams diferentes

  Future<void> stopMeasurement(String userId, String measurementId) async {
    _measurementService.stopMeasuring(measurementId);
    _measurementService.saveMeasurement(userId, measurementId);
  }

  Measurement? getMeasurement(String measurementId) {
    return _measurementService.getMeasurement(measurementId);
  }

  Future<void> syncMeasurements(String deviceIdentifier,
      AuthProfile authProfile, Duration workSamplingTime) async {
    await _measurementService.syncMeasurements(authProfile, workSamplingTime);
  }

  Future<BluetoothDev?> loadDevice() => _deviceService.loadBluetoothDev();

  setStandby() => _deviceService.setStandby();

  Future<int> getBatteryStatus() {
    return _deviceService.getBatteryLevel();
  }

  Future<void> reloadStorage() async => await _deviceService.reloadStorage();
}
