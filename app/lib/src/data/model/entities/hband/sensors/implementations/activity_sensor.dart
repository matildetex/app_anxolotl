import 'package:anxolotl_app/src/data/model/entities/common/measurement_protocols/activity_measurement_protocol.dart';
import 'package:anxolotl_app/src/data/model/entities/common/sensor/sensor.dart';
import 'package:anxolotl_app/src/data/model/entities/common/sensor/sensor_frequency.dart';
import 'package:anxolotl_app/src/data/model/entities/common/bit_utils.dart';
import 'package:anxolotl_app/src/data/model/entities/hband/hband_hardware_ids.dart';
import 'package:anxolotl_app/src/data/model/entities/hband/sensors/hband_sensor.dart';
import 'package:anxolotl_app/src/data/model/entities/measurements/measurement_input_type.dart';

class ActivitySensor extends HBandSensor {
  ActivitySensor(MeasurementInfo measurementInfo, SensorFrequency frequency)
      : super(
            measurementInfo: measurementInfo,
            sensorFrequency: frequency,
            sensor: Sensor.ACTIVITY,
            serviceName: HBandServices.PULSEON_SERVICE,
            characteristicName: HBandCharacteristics
                .pulseOnServiceCharacteristics.ACTIVITY_DATA,
            dataSizePerMeasurement: 11);

  @override
  ActivityMeasurementProtocol parseSensorValue(List<int> readValues) {
    PulseOnActivity activity = PulseOnActivity(readValues);
    print('Activity : ${activity.activityType.name}');
    return activity.toMeasurementProtocol();
  }

  @override
  List<int> getSensorRequisites(List<int> readValues) {
    return readValues
        //.setBitData(0, 1, 0x1)
        //.setBitData(1, 3, 0x07) // OperatingMode
        .setBitData(4, 8, 0x04) //AnalysisSet
        .setBitData(12, 8, 0x03); //Raw Data*/
  }
}

class PulseOnActivity {
  late final bool workoutStatusChanged;
  late final bool wornStatusChanged;
  late final bool activityDataChanged;
  late final int rollingCounter;
  late final int kCalories;
  late final int speed;
  late final int steps;
  late final int distance;
  late final _ActivityType activityType;
  late final bool workoutState;
  late final bool wornState;

  PulseOnActivity(List<int> readValues) {
    workoutStatusChanged = readValues.getBitData(4, 1) == 0x1;
    wornStatusChanged = readValues.getBitData(5, 1) == 0x1;
    activityDataChanged = readValues.getBitData(6, 1) == 0x1;
    rollingCounter = readValues.getBitData(7, 32);
    kCalories = readValues.getBitData(39, 24);
    speed = readValues.getBitData(63, 16);
    steps = readValues.getBitData(79, 24);
    distance = readValues.getBitData(103, 24);
    activityType = _ActivityType.values[readValues.getBitData(127, 4)];
    workoutState = readValues.getBitData(131, 1) == 0x1;
    wornState = readValues.getBitData(132, 1) == 0x1;
  }

  ActivityMeasurementProtocol toMeasurementProtocol() {
    return ActivityMeasurementProtocol(
        dailyCalories: kCalories,
        speed: speed,
        dailySteps: steps,
        dailyDistance: distance,
        activityType: activityType.name,
        workoutState: workoutState,
        sensorWorn: wornState);
  }
}

enum _ActivityType {
  REST,
  OTHER,
  WALKING,
  RUNNING,
  BIKING,
  OTHER_RYTHMIC,
  SLEEPING_UNDETERMINED,
  SLEEPING_LIGHT,
  SLEEPING_DEEP
}
