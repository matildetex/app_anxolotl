import 'package:objectbox/objectbox.dart';

@Entity()
class MeasurementRowEntryDbDto {
  @Id()
  int id = 0;
  final String measurementId;
  @Property(type: PropertyType.date)
  final DateTime timestamp;
  final String key;
  final String value;

  MeasurementRowEntryDbDto(
      this.measurementId, this.timestamp, this.key, this.value);
}
