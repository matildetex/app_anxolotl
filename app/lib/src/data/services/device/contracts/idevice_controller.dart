import 'package:anxolotl_app/src/data/model/entities/common/idevice.dart';
import 'package:anxolotl_app/src/data/model/entities/common/sensor/sensor.dart';
import 'package:anxolotl_app/src/data/model/entities/common/sensor_info.dart';
import 'package:anxolotl_app/src/data/services/bluetooth/bluetooth_dev.dart';
import 'package:anxolotl_app/src/data/services/device/contracts/acquisition_objects.dart';
import 'package:anxolotl_app/src/data/services/device/device_service.dart';

abstract class IDeviceController<T extends AcquisitionInfo, U extends IDevice> {
  abstract final U device;

  Future<bool> connectDevice(BluetoothDev bluetoothDev);

  Future<bool> disconnectDevice();

  Future<void> setStandby();

  bool isDeviceConnected();

  String getDeviceIdentifier();

  Future<bool> configureBand(MeasuringMode measuringMode,
      {Duration? samplingRate});

  Future<Iterable<AcquisitionStream>> startAcquisition(
      AcquisitionInfo acquisitionObject);

  Future<bool> stopAcquisition(Sensor sensor);

  bool isMeasuring();

  SensorMeasurementInfo getSensorInfo(Sensor sensor);

  Iterable<IDeviceConfig> getAllDeviceConfigs();

  IDeviceConfig getDeviceConfig();

  Iterable<Sensor> getDeviceSensors();

  Future<List<int>> getBatteryLevel();

  void changeDeviceConfig(IDeviceConfig deviceConfig);
}
