import 'package:anxolotl_app/src/data/data_acces/dto/api/user_info/user_device_json_dto.dart';
import 'package:anxolotl_app/src/data/data_acces/dto/api/user_info/user_info_json_dto.dart';
import 'package:anxolotl_app/src/data/model/user/user_health_profile.dart';
import 'package:anxolotl_app/src/data/model/user/user_profile.dart';

class UserInfoDataMapper {
  static UserProfileJsonDto userProfileToUserProfileDto(
      AuthProfile authProfile, HealthProfile healthProfile) {
    return UserProfileJsonDto(
        userId: authProfile.id,
        gender: healthProfile.gender.toString().split(".").last,
        birthday: healthProfile.birthday!.millisecondsSinceEpoch,
        height: healthProfile.height,
        weight: healthProfile.weight);
  }

  static UserDeviceJsonDto userDeviceToUserDeviceDto(
      String userId, String? blDeviceMac) {
    return UserDeviceJsonDto(userId: userId, blDeviceId: blDeviceMac);
  }
}
