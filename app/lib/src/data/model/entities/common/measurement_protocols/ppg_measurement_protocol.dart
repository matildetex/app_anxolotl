import 'package:anxolotl_app/src/data/model/entities/common/measurement_protocols/a_measurement_protocol.dart';

class PpgMeasurementProtocol implements MeasurementProtocol {
  late final int ppg0;
  late final int? ppg1;
  late final int? ppg2;
  late final int? ppg3;
  late final int? ppg4;
  late final int timestamp;

  PpgMeasurementProtocol(
      {required this.ppg0,
      this.ppg1,
      this.ppg2,
      this.ppg3,
      this.ppg4,
      DateTime? measureTimestamp}) {
    if (measureTimestamp != null) {
      timestamp = measureTimestamp.millisecondsSinceEpoch;
    } else {
      timestamp = DateTime.now().millisecondsSinceEpoch;
    }
  }

  @override
  void fromMap(Map<String, dynamic> valuesMap) {
    ppg0 = int.parse(valuesMap['ppg0']);
    ppg1 = int.parse(valuesMap['ppg1']);
    ppg2 = int.parse(valuesMap['ppg2']);
    ppg3 = int.parse(valuesMap['ppg3']);
    ppg4 = int.parse(valuesMap['ppg4']);
    timestamp = int.parse(valuesMap['timestamp']);
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'ppg0': ppg0,
      'ppg1': ppg1 ?? 0,
      'ppg2': ppg2 ?? 0,
      'ppg3': ppg3 ?? 0,
      'ppg4': ppg4 ?? 0,
      'timestamp': timestamp,
    };
  }
}
