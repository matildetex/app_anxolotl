import 'package:anxolotl_app/src/data/model/entities/common/measurement_protocols/hr_measurement_protocol.dart';
import 'package:anxolotl_app/src/data/model/entities/common/sensor/sensor.dart';
import 'package:anxolotl_app/src/data/model/entities/common/sensor/sensor_frequency.dart';
import 'package:anxolotl_app/src/data/model/entities/common/bit_utils.dart';
import 'package:anxolotl_app/src/data/model/entities/hband/hband_hardware_ids.dart';
import 'package:anxolotl_app/src/data/model/entities/hband/sensors/hband_sensor.dart';
import 'package:anxolotl_app/src/data/model/entities/measurements/measurement_input_type.dart';

class HeartRateSensor extends HBandSensor {
  HeartRateSensor(MeasurementInfo measurementInfo, SensorFrequency frequency)
      : super(
            measurementInfo: measurementInfo,
            sensorFrequency: frequency,
            sensor: Sensor.HR,
            serviceName: HBandServices.PULSEON_SERVICE,
            characteristicName: HBandCharacteristics
                .pulseOnServiceCharacteristics.HEART_RATE_DATA,
            dataSizePerMeasurement: 8);

  @override
  HrMeasurementProtocol parseSensorValue(List<int> readValues) =>
      PulseOnHeartRate(readValues).toMeasurementProtocol();

  @override
  List<int> getSensorRequisites(List<int> readValues) {
    return readValues
        //.setBitData(0, 1, 0x1)
        //.setBitData(1, 3, 0x07) // OperatingMode
        .setBitData(4, 8, 0x41) //AnalysisSet
        .setBitData(12, 8, 0x10); //Raw Data*/
    //.setBitData(36, 16, 10) // HR Data Interval in millis
    //.setBitData(52, 16, 10) // HR Sampling Interval in seconds
    //.setBitData(84, 16, 100); // HR Max Seeking Duration in millis
  }
}

class PulseOnHeartRate {
  late final int rollingCounter;
  late final bool hrReliable;
  late final bool hrAtTimeOut;
  late final bool newIbiData;

  late final int hr;
  late final int hrQuality;
  late final int ibi;
  late final int ibiQuality;

  PulseOnHeartRate(List<int> readValues) {
    rollingCounter = readValues.getBitData(0, 32);
    hrReliable = readValues.getBitData(32, 1) == 0x1;
    hrAtTimeOut = readValues.getBitData(33, 1) == 0x1;
    newIbiData = readValues.getBitData(34, 1) == 0x1;
    hr = readValues.getBitData(35, 8);
    hrQuality = readValues.getBitData(43, 8);
    ibi = readValues.getBitData(51, 16);
    ibiQuality = readValues.getBitData(67, 8);
  }

  HrMeasurementProtocol toMeasurementProtocol() {
    return HrMeasurementProtocol(
      sensorWorn: hrReliable,
      heartRate: hr,
      energyExpended: null,
      rrInterval: ibi,
    );
  }
}
