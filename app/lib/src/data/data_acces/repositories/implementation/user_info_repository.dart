import 'package:anxolotl_app/src/data/data_acces/api/amqp/amqp_api.dart';
import 'package:anxolotl_app/src/data/data_acces/dto/api/mapper/user_info_data_mapper.dart';
import 'package:anxolotl_app/src/data/data_acces/dto/api/user_info/user_device_json_dto.dart';
import 'package:anxolotl_app/src/data/data_acces/dto/api/user_info/user_info_json_dto.dart';
import 'package:anxolotl_app/src/data/model/user/user_health_profile.dart';
import 'package:anxolotl_app/src/data/model/user/user_profile.dart';

class UserInfoRepository {
  final AmqpApi amqpApi;

  UserInfoRepository(this.amqpApi);

  Future<void> uploadUserProfile(
      AuthProfile authProfile, HealthProfile healthProfile) async {
    UserProfileJsonDto userProfileJsonDto =
        UserInfoDataMapper.userProfileToUserProfileDto(
            authProfile, healthProfile);
    await amqpApi.uploadUserProfile(userProfileJsonDto);
  }

  Future<void> uploadUserDevice(String userId, String? deviceMac) async {
    UserDeviceJsonDto userDeviceJsonDto =
        UserInfoDataMapper.userDeviceToUserDeviceDto(userId, deviceMac);
    await amqpApi.uploadUserDevice(userDeviceJsonDto);
  }
}
