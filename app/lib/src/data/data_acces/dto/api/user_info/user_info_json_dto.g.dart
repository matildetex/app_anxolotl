// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_info_json_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserProfileJsonDto _$UserProfileJsonDtoFromJson(Map<String, dynamic> json) =>
    UserProfileJsonDto(
      userId: json['userId'] as String,
      birthday: json['birthday'] as int,
      gender: json['gender'] as String,
      height: json['height'] as int?,
      weight: json['weight'] as int?,
    );

Map<String, dynamic> _$UserProfileJsonDtoToJson(UserProfileJsonDto instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'birthday': instance.birthday,
      'gender': instance.gender,
      'height': instance.height,
      'weight': instance.weight,
    };
