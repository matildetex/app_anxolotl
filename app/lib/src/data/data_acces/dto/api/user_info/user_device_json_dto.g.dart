// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_device_json_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserDeviceJsonDto _$UserDeviceJsonDtoFromJson(Map<String, dynamic> json) =>
    UserDeviceJsonDto(
      userId: json['userId'] as String,
      blDeviceId: json['blDeviceId'] as String?,
    );

Map<String, dynamic> _$UserDeviceJsonDtoToJson(UserDeviceJsonDto instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'blDeviceId': instance.blDeviceId,
    };
