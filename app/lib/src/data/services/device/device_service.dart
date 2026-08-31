import 'package:anxolotl_app/src/data/data_acces/repositories/implementation/user_info_repository.dart';
import 'package:anxolotl_app/src/data/data_acces/repositories/shared_preferences_repository.dart';
import 'package:anxolotl_app/src/data/model/entities/common/device_implementations.dart';
import 'package:anxolotl_app/src/data/model/entities/common/idevice.dart';
import 'package:anxolotl_app/src/data/model/entities/common/sensor/sensor.dart';
import 'package:anxolotl_app/src/data/model/entities/common/sensor_info.dart';
import 'package:anxolotl_app/src/data/services/bluetooth/bluetooth_dev.dart';
import 'package:anxolotl_app/src/data/services/device/contracts/acquisition_objects.dart';
import 'package:anxolotl_app/src/data/services/device/contracts/idevice_controller.dart';
import 'package:notification_permissions/notification_permissions.dart';

enum MeasuringMode { DISCRETE, CONTINUOUS }

class DeviceService {
  late IDeviceController _deviceController;
  late DeviceImplementations _deviceImplementation;
  late BluetoothDev? _connectedDevice;
  final SharedPreferencesRepository _securedStorageRepo;
  final UserInfoRepository userInfoRepository;

  DeviceService(this._securedStorageRepo, this.userInfoRepository,
      {DeviceImplementations deviceImplementation =
          DeviceImplementations.HBAND}) {
    _deviceImplementation = deviceImplementation;
    _deviceController = _deviceImplementation.deviceController;
  }

  Future<void> askForPermissions() async {
    await NotificationPermissions.requestNotificationPermissions();
  }

  ///
  /// Bluetooths - pensar passar para o BL service, mas nesse caso o controller tem de ser passado aos dois
  Future<bool> connectToDevice(BluetoothDev bluetoothDev) async {
    bool didConnect = await _deviceController.connectDevice(bluetoothDev);
    if (didConnect) {
      int batteryLevel = await getBatteryLevel();
      bluetoothDev.batteryValue = batteryLevel;
      _connectedDevice = bluetoothDev;
      await _securedStorageRepo.storeSerializable<BluetoothDev>(bluetoothDev);
    }
    return didConnect;
  }

  BluetoothDev getConnectedDevice() => _connectedDevice!;

  /// In the case of finishing, the bluetooth device, should not be removed from storage
  Future<bool> disconnectDevice({bool removeFromMemory = true}) async {
    bool disconnected = await _deviceController.disconnectDevice();
    _connectedDevice = null;
    if (removeFromMemory) {
      print("### Removing bl device from storage");
      await _securedStorageRepo.removeSerialized<BluetoothDev>();
      _restartController();
    }
    return disconnected;
  }

  Future<void> setStandby() async => await _deviceController.setStandby();

  Future<void> configureDevice(MeasuringMode measuringMode,
          {Duration? samplingRate}) async =>
      await _deviceController.configureBand(measuringMode,
          samplingRate: samplingRate);

  bool isDeviceConnected() => _deviceController.isDeviceConnected();

  String getDeviceIdentifier() =>
      isDeviceConnected() ? _deviceController.getDeviceIdentifier() : "";

  String getDeviceName() =>
      isDeviceConnected() ? _deviceController.device.name : "";

  ///

  void changeDevice(DeviceImplementations deviceImplementation) {
    _deviceImplementation = deviceImplementation;
    _deviceController = deviceImplementation.deviceController;
  }

  DeviceImplementations getDeviceImplementation() => _deviceImplementation;

  void changeDeviceConfig(IDeviceConfig deviceConfig) =>
      _deviceController.changeDeviceConfig(deviceConfig);

  IDeviceController getDeviceController(IDeviceConfig deviceConfig) =>
      _deviceController;

  Iterable<IDeviceConfig> getAllDeviceConfigs() =>
      _deviceController.getAllDeviceConfigs();

  IDeviceConfig getDeviceConfig() => _deviceController.getDeviceConfig();

  Iterable<Sensor> getDeviceSensors() => _deviceController.getDeviceSensors();

  SensorMeasurementInfo getSensorInfo(Sensor sensor) =>
      _deviceController.getSensorInfo(sensor);

  Future<AcquisitionStream> startAcquisition(Sensor sensor) async {
    return await startMultiAcquisition([sensor]).then((value) => value.first);
  }

  Future<Iterable<AcquisitionStream>> startMultiAcquisition(
      Iterable<Sensor> sensors) {
    AcquisitionInfo acquisitionInfo = AcquisitionInfo(sensors: sensors);
    return _deviceController.startAcquisition(acquisitionInfo);
  }

  Future<bool> stopAcquisition(Sensor sensor) =>
      _deviceController.stopAcquisition(sensor);

  bool isMeasuring() => _deviceController.isDeviceConnected();

  void _restartController() {
    _deviceController = _deviceImplementation.deviceController;
  }

  Future<int> getBatteryLevel() async {
    return (await _deviceController.getBatteryLevel()).first;
  }

  Future<BluetoothDev?> loadBluetoothDev() async =>
      _securedStorageRepo.readSerialized<BluetoothDev>();

  Future<void> uploadBluetoothDev(String userId) =>
      userInfoRepository.uploadUserDevice(userId, getDeviceIdentifier());

  Future<void> reloadStorage() => _securedStorageRepo.reloadStorage();
}
