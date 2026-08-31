import 'package:anxolotl_app/src/data/model/entities/common/sensor/sensor_frequency.dart';
import 'package:anxolotl_app/src/data/model/entities/hband/hband_device.dart';
import 'package:anxolotl_app/src/data/model/entities/hband/sensors/hband_sensor.dart';
import 'package:anxolotl_app/src/data/model/entities/hband/sensors/implementations/activity_sensor.dart';
import 'package:anxolotl_app/src/data/model/entities/hband/sensors/implementations/ibi_sensor.dart';
import 'package:anxolotl_app/src/data/model/entities/measurements/measurement_input_type.dart';

class HBandDefaultConfig extends IHBandConfig {
  @override
  final String name = "HBandDefaultConfig";

  @override
  late List<HBandSensor> sensors = [
    //HeartRateSensor(MeasurementInfo(MeasurementType.DISCRETE), SensorFrequency.HZ1),
    ActivitySensor(
        MeasurementInfo(MeasurementType.DISCRETE), SensorFrequency.HZ1),
    IBISensor(MeasurementInfo(MeasurementType.DISCRETE), SensorFrequency.HZ1),
    //PPGSensor(MeasurementInfo(MeasurementType.DISCRETE), SensorFrequency.HZ1),
  ];
}
