import 'package:anxolotl_app/src/data/model/entities/common/sensor/sensor.dart';

///Used to represent all the configurations allowed in the devices.
abstract class IDevice<T extends IDeviceConfig> {
  /// The name given to this configuration
  abstract final String name;

  abstract T currentConfig;
  abstract final List<T> configs;

  IDevice() {
    currentConfig = configs.first;
  }

  Iterable<IDeviceConfig> getConfigs();

  Iterable<Sensor> getDeviceSensors();
}

///Used to represent all the configurations allowed in the devices.
abstract class IDeviceConfig<T> {
  /// The name given to this configuration
  abstract final String name;

  @override
  String toString() => name;
}
