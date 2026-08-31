import 'package:anxolotl_app/src/data/data_acces/dto/api/measurements/measurement_row_json_dto.dart';
import 'package:json_annotation/json_annotation.dart';

part 'measurement_json_dto.g.dart';

@JsonSerializable()
class MeasurementJsonDto {
  final String userId;
  final String measurementId;
  final int measurementType;
  final List<MeasurementRowJsonDto> results;

  MeasurementJsonDto(
      this.userId, this.measurementId, this.measurementType, this.results);

  factory MeasurementJsonDto.fromJson(Map<String, dynamic> json) =>
      _$MeasurementJsonDtoFromJson(json);

  Map<String, dynamic> toJson() => _$MeasurementJsonDtoToJson(this);
}
