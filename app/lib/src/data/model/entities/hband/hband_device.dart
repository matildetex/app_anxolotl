import 'package:anxolotl_app/src/data/model/entities/common/idevice.dart';
import 'package:anxolotl_app/src/data/model/entities/common/sensor/sensor.dart';
import 'package:anxolotl_app/src/data/model/entities/hband/configurations/hband_default_config.dart';
import 'package:anxolotl_app/src/data/model/entities/hband/sensors/hband_sensor.dart';

///Used to represent all the configurations allowed in the devices.
class IHBandDevice extends IDevice<IHBandConfig> {
  /// The name given to this configuration
  @override
  final String name = "HBand";

  /// The full list of sensors that this configuration has attached to it,
  /// it must contain the full information about the sensors as how they work,
  /// the channels and the units
  ///WARNING : IT NEEDS TO BE DECLARED AS LATE
  @override
  late IHBandConfig currentConfig;

  @override
  List<IHBandConfig> configs = [HBandDefaultConfig()];

  HBandSensor getSensorModule(Sensor sensor) =>
      currentConfig.getSensorByName(sensor);

  @override
  Iterable<IDeviceConfig> getConfigs() => configs;

  @override
  Iterable<Sensor> getDeviceSensors() => currentConfig.getDeviceSensors();

  void setConfig(IHBandConfig newConfig) => currentConfig = newConfig;
}

abstract class IHBandConfig extends IDeviceConfig {
  abstract final List<HBandSensor> sensors;

  HBandSensor getSensorByName(Sensor sensor) =>
      sensors.firstWhere((sensorModule) => sensorModule.sensor == sensor);

  Iterable<Sensor> getDeviceSensors() =>
      sensors.map((hbandSensor) => hbandSensor.sensor);
}
