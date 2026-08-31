import 'package:json_annotation/json_annotation.dart';

part 'measurement_row_json_dto.g.dart';

@JsonSerializable()
class MeasurementRowJsonDto {
  final Map<String, dynamic> resultsRow;

  MeasurementRowJsonDto(this.resultsRow);

  factory MeasurementRowJsonDto.fromJson(Map<String, dynamic> json) =>
      _$MeasurementRowJsonDtoFromJson(json);

  Map<String, dynamic> toJson() => _$MeasurementRowJsonDtoToJson(this);
}
