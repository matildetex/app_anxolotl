import 'package:anxolotl_app/src/data/model/entities/common/sensor/sensor.dart';
import 'package:anxolotl_app/src/data/model/entities/common/sensor/sensor_frequency.dart';

abstract class ISensor {
  final Sensor sensorName;
  final SensorFrequency preferredFrequency;

  ISensor(this.sensorName, this.preferredFrequency);
}
