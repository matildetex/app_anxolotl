import 'package:anxolotl_app/src/data/model/entities/common/sensor/sensor_frequency.dart';
import 'package:anxolotl_app/src/data/model/entities/measurements/measurement_input_type.dart';

class SensorMeasurementInfo {
  final MeasurementInfo measurementInfo;
  final SensorFrequency sensorFrequency;
  //final int dataSizePerMeasurement;
  //final List<String> divisions;
  //final List<String> units;

  //SensorInfo(this.workingFrequency, this.divisions, this.units);
  SensorMeasurementInfo(this.measurementInfo, this.sensorFrequency);
}
