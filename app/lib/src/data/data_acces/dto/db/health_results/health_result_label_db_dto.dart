import 'package:objectbox/objectbox.dart';

@Entity()
class HealthResultLabelDbDto {
  @Id()
  int id = 0;
  late final String userId;
  late final double labelValue;
  late final int timestamp;

  HealthResultLabelDbDto(this.userId, this.labelValue, this.timestamp);

  HealthResultLabelDbDto.fromJson(Map<dynamic, dynamic> jsonMap) {
    userId = jsonMap["userId"]!;
    labelValue = jsonMap["labelValue"]!;
    timestamp = jsonMap["timestamp"]!;
  }
}
