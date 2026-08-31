import 'package:anxolotl_app/src/data/model/entities/common/measurement_protocols/a_measurement_protocol.dart';

class ActivityMeasurementProtocol implements MeasurementProtocol {
  late final int dailyCalories;
  late final int speed;
  late final int dailySteps;
  late final int dailyDistance;
  late final String activityType;
  late final bool workoutState;
  late final bool sensorWorn;
  late final int timestamp; // In millis since epoch

  ActivityMeasurementProtocol(
      {required this.dailyCalories,
      required this.speed,
      required this.dailySteps,
      required this.dailyDistance,
      required this.activityType,
      required this.workoutState,
      required this.sensorWorn,
      DateTime? measureTimestamp}) {
    if (measureTimestamp != null) {
      timestamp = measureTimestamp.millisecondsSinceEpoch;
    } else {
      timestamp = DateTime.now().millisecondsSinceEpoch;
    }
  }

  ActivityMeasurementProtocol.empty();

  @override
  ActivityMeasurementProtocol fromMap(Map<String, dynamic> valuesMap) {
    dailyCalories = valuesMap['dailyCalories'];
    speed = valuesMap['speed'];
    dailySteps = valuesMap['dailySteps'];
    dailyDistance = valuesMap['dailyDistance'];
    activityType = valuesMap['activityType'];
    workoutState = valuesMap['workoutState'];
    sensorWorn = valuesMap['sensorWorn'];
    timestamp = valuesMap['timestamp'];
    return this;
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'dailyCalories': dailyCalories,
      'speed': speed,
      'dailySteps': dailySteps,
      'dailyDistance': dailyDistance,
      'activityType': activityType,
      'workoutState': workoutState,
      'sensorWorn': sensorWorn,
      'timestamp': timestamp,
    };
  }

  static bool filterValue(Map<String, dynamic> values) {
    ActivityMeasurementProtocol activityMeasurementProtocol =
        ActivityMeasurementProtocol.empty().fromMap(values);
    return activityMeasurementProtocol.sensorWorn == true;
  }
}
