import 'package:anxolotl_app/src/data/model/entities/common/measurement_protocols/a_measurement_protocol.dart';

class HrMeasurementProtocol implements MeasurementProtocol {
  late final bool
      sensorWorn; // 0,1 - unsupported, 2 - supported but no contact detected, 3 - supported and contact detected
  late final int heartRate;
  late final int? energyExpended;
  late final int? rrInterval;
  late final int timestamp; // In millis since epoch

  HrMeasurementProtocol(
      {required this.sensorWorn,
      required this.heartRate,
      this.energyExpended,
      this.rrInterval,
      DateTime? measureTimestamp}) {
    if (measureTimestamp != null) {
      timestamp = measureTimestamp.millisecondsSinceEpoch;
    } else {
      timestamp = DateTime.now().millisecondsSinceEpoch;
    }
  }

  HrMeasurementProtocol.empty();

  @override
  HrMeasurementProtocol fromMap(Map<String, dynamic> valuesMap) {
    sensorWorn = valuesMap['sensorWorn'];
    heartRate = valuesMap['heartRate'];
    energyExpended = valuesMap['energyExpended'];
    rrInterval = valuesMap['rrInterval'];
    timestamp = valuesMap['timestamp'];
    return this;
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'sensorWorn': sensorWorn,
      'heartRate': heartRate,
      'energyExpended': energyExpended ?? 0,
      'rrInterval': rrInterval ?? 0,
      'timestamp': timestamp
    };
  }

  static bool filterValue(Map<String, dynamic> values) {
    HrMeasurementProtocol activityMeasurementProtocol =
        HrMeasurementProtocol.empty().fromMap(values);
    return activityMeasurementProtocol.sensorWorn == true;
  }
}
