// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'measurement_json_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MeasurementJsonDto _$MeasurementJsonDtoFromJson(Map<String, dynamic> json) =>
    MeasurementJsonDto(
      json['userId'] as String,
      json['measurementId'] as String,
      json['measurementType'] as int,
      (json['results'] as List<dynamic>)
          .map((e) => MeasurementRowJsonDto.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$MeasurementJsonDtoToJson(MeasurementJsonDto instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'measurementId': instance.measurementId,
      'measurementType': instance.measurementType,
      'results': instance.results,
    };
