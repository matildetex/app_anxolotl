import 'package:anxolotl_app/src/data/model/entities/common/measurement_protocols/a_measurement_protocol.dart';
import 'package:anxolotl_app/src/data/model/entities/common/sensor/sensor.dart';
import 'package:anxolotl_app/src/data/model/entities/common/sensor/sensor_frequency.dart';
import 'package:anxolotl_app/src/data/model/entities/measurements/measurement_input_type.dart';

abstract class HBandSensor {
  final MeasurementInfo measurementInfo;

  final SensorFrequency sensorFrequency;

  final Sensor sensor;
  final String serviceName;
  final String characteristicName;
  final int dataSizePerMeasurement;

  HBandSensor(
      {required this.measurementInfo,
      required this.sensorFrequency,
      required this.sensor,
      required this.serviceName,
      required this.characteristicName,
      required this.dataSizePerMeasurement});

  List<int> getSensorRequisites(List<int> readValues);

  MeasurementProtocol parseSensorValue(List<int> readValues);
}
