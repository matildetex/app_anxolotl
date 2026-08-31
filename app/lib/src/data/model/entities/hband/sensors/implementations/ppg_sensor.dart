import 'package:anxolotl_app/src/data/model/entities/common/measurement_protocols/ppg_measurement_protocol.dart';
import 'package:anxolotl_app/src/data/model/entities/common/sensor/sensor.dart';
import 'package:anxolotl_app/src/data/model/entities/common/sensor/sensor_frequency.dart';
import 'package:anxolotl_app/src/data/model/entities/common/bit_utils.dart';
import 'package:anxolotl_app/src/data/model/entities/hband/hband_hardware_ids.dart';
import 'package:anxolotl_app/src/data/model/entities/hband/sensors/hband_sensor.dart';
import 'package:anxolotl_app/src/data/model/entities/measurements/measurement_input_type.dart';

class PPGSensor extends HBandSensor {
  PPGSensor(MeasurementInfo measurementInfo, SensorFrequency frequency)
      : super(
            measurementInfo: measurementInfo,
            sensorFrequency: frequency,
            sensor: Sensor.PPG,
            serviceName: HBandServices.PULSEON_SERVICE,
            characteristicName:
                HBandCharacteristics.pulseOnServiceCharacteristics.PPG_DATA,
            dataSizePerMeasurement: 8);

  @override
  PpgMeasurementProtocol parseSensorValue(List<int> readValues) =>
      PulseOnPPGData(readValues).toMeasurementProtocol();

  @override
  List<int> getSensorRequisites(List<int> readValues) {
    return readValues
        //.setBitData(0, 1, 0x1)
        //.setBitData(1, 3, 0x05) // OperatingMode
        .setBitData(4, 8, 0x43) //AnalysisSet
        .setBitData(12, 8, 0x12); //Raw Data*/
    //.setBitData(36, 16, 10) // HR Data Interval in millis
    //.setBitData(52, 16, 10) // HR Sampling Interval in seconds
    //.setBitData(84, 16, 100); // HR Max Seeking Duration in millis
  }
}

class PulseOnPPGData {
  late final _ReducedPPGData ppg0;
  late final _ReducedPPGData ppg1;
  late final _ReducedPPGData ppg2;
  late final _ReducedPPGData ppg3;
  late final _ReducedPPGData ppg4;

  PulseOnPPGData(List<int> readValues) {
    ppg0 = _ReducedPPGData(
        readValues.getBitData(0, 16), readValues.getBitData(16, 16));
    ppg1 = _ReducedPPGData(
        readValues.getBitData(32, 16), readValues.getBitData(48, 16));
    ppg2 = _ReducedPPGData(
        readValues.getBitData(64, 16), readValues.getBitData(80, 16));
    ppg3 = _ReducedPPGData(
        readValues.getBitData(96, 16), readValues.getBitData(112, 16));
    ppg4 = _ReducedPPGData(
        readValues.getBitData(128, 16), readValues.getBitData(144, 16));
  }

  PpgMeasurementProtocol toMeasurementProtocol() {
    return PpgMeasurementProtocol(
      ppg0: ppg0.ppg,
      ppg1: ppg1.ppg,
      ppg2: ppg2.ppg,
      ppg3: ppg3.ppg,
      ppg4: ppg4.ppg,
    );
  }
}

class _ReducedPPGData {
  final int timestamp;
  final int ppg;

  _ReducedPPGData(this.timestamp, this.ppg);
}
