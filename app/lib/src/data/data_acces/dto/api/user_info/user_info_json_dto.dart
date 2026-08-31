import 'package:json_annotation/json_annotation.dart';

part 'user_info_json_dto.g.dart';

@JsonSerializable()
class UserProfileJsonDto {
  final String userId;
  final int birthday;
  final String gender;
  final int? height;
  final int? weight;

  UserProfileJsonDto(
      {required this.userId,
      required this.birthday,
      required this.gender,
      this.height,
      this.weight});

  factory UserProfileJsonDto.fromJson(Map<String, dynamic> json) =>
      _$UserProfileJsonDtoFromJson(json);

  Map<String, dynamic> toJson() => _$UserProfileJsonDtoToJson(this);
}
