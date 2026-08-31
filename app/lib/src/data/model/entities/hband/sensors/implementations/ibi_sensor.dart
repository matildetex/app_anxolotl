import 'package:anxolotl_app/src/data/model/entities/common/measurement_protocols/hr_measurement_protocol.dart';
import 'package:anxolotl_app/src/data/model/entities/common/sensor/sensor.dart';
import 'package:anxolotl_app/src/data/model/entities/common/sensor/sensor_frequency.dart';
import 'package:anxolotl_app/src/data/model/entities/common/bit_utils.dart';
import 'package:anxolotl_app/src/data/model/entities/hband/hband_hardware_ids.dart';
import 'package:anxolotl_app/src/data/model/entities/hband/sensors/hband_sensor.dart';
import 'package:anxolotl_app/src/data/model/entities/measurements/measurement_input_type.dart';

class IBISensor extends HBandSensor {
  IBISensor(MeasurementInfo measurementInfo, SensorFrequency frequency)
      : super(
            measurementInfo: measurementInfo,
            sensorFrequency: frequency,
            sensor: Sensor.IBI,
            serviceName: HBandServices.HEART_RATE_SERVICE,
            characteristicName: HBandCharacteristics
                .heartRateServiceCharacteristics.HEART_RATE_MEASUREMENT,
            dataSizePerMeasurement: 5);

  @override
  HrMeasurementProtocol parseSensorValue(List<int> readValues) =>
      IbiServiceObject(readValues).toMeasurementProtocol();

  @override
  List<int> getSensorRequisites(List<int> readValues) {
    return readValues
        //.setBitData(0, 1, 0x1)
        //.setBitData(1, 3, 0x05) // OperatingMode
        .setBitData(4, 8, 0x41) //AnalysisSet
        .setBitData(12, 8, 0x10); //Raw Data*/
    //.setBitData(36, 16, 10) // HR Data Interval in millis
    //.setBitData(52, 16, 10) // HR Sampling Interval in seconds
    //.setBitData(84, 16, 100); // HR Max Seeking Duration in millis
  }
}

class IbiServiceObject {
  late final bool heartRateFormat; // 0 for 8 bit and 1 for 16 bit
  late final int
      sensorContactStatus; // 0,1 - unsupported, 2 - supported but no contact detected, 3 - supported and contact detected

  late final int heartRateMeasurement;
  late final int? energyExpended;
  late int? rrInterval;

  IbiServiceObject(List<int> readValues) {
    heartRateFormat = readValues.getBitData(0, 1) == 1;
    sensorContactStatus = readValues.getBitData(1, 2);
    bool energyExpendedStatusPresent = readValues.getBitData(3, 1) == 1;
    bool RRIntervalStatusPresent = readValues.getBitData(4, 1) == 1;

    int index = 8;
    int valueLength = 8;
    if (heartRateFormat) valueLength = 16;
    heartRateMeasurement = readValues.getBitData(index, valueLength);
    index += valueLength;

    if (energyExpendedStatusPresent) {
      valueLength = 16;
      energyExpended = readValues.getBitData(index, valueLength);
      index += valueLength;
    } else {
      energyExpended = null;
    }

    if (RRIntervalStatusPresent) {
      valueLength = 16;
      rrInterval = readValues.getBitData(index, valueLength);
      index += valueLength;
    } else {
      rrInterval = null;
    }
  }

  HrMeasurementProtocol toMeasurementProtocol() {
    if (rrInterval == null && heartRateMeasurement > 0) {
      rrInterval = ((1 / heartRateMeasurement) * 60 * 1000).toInt();
    }

    return HrMeasurementProtocol(
      sensorWorn: sensorContactStatus == 3,
      heartRate: heartRateMeasurement,
      energyExpended: energyExpended,
      rrInterval: rrInterval,
    );
  }
}
