import 'package:json_annotation/json_annotation.dart';

part 'user_device_json_dto.g.dart';

@JsonSerializable()
class UserDeviceJsonDto {
  final String userId;
  final String? blDeviceId;

  UserDeviceJsonDto({required this.userId, required this.blDeviceId});

  factory UserDeviceJsonDto.fromJson(Map<String, dynamic> json) =>
      _$UserDeviceJsonDtoFromJson(json);

  Map<String, dynamic> toJson() => _$UserDeviceJsonDtoToJson(this);
}
