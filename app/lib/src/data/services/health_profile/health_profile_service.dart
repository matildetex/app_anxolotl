import 'package:anxolotl_app/src/data/data_acces/repositories/implementation/user_info_repository.dart';
import 'package:anxolotl_app/src/data/model/user/user_health_profile.dart';
import 'package:anxolotl_app/src/data/model/user/user_profile.dart';
import 'package:anxolotl_app/src/data/services/health_profile/utils.dart';
import 'package:anxolotl_app/src/data/data_acces/repositories/secure_storage_repository.dart';

class HealthProfileService {
  final HealthProfile _healthProfile = HealthProfile.empty();
  final SecureStorageRepository _sharedPreferencesRepo;
  final UserInfoRepository _userInfoRepository;

  HealthProfileService(this._sharedPreferencesRepo, this._userInfoRepository);

  HealthProfile getHealthProfile() => _healthProfile;

  void changeUserHeight(int height, String userId) {
    _healthProfile.height = height;
    _sharedPreferencesRepo.storeSerializable<HealthProfile>(_healthProfile,
        authId: userId);
  }

  void changeUserWeight(int weight, String userId) {
    _healthProfile.weight = weight;
    _sharedPreferencesRepo.storeSerializable<HealthProfile>(_healthProfile,
        authId: userId);
  }

  void changeUserGender(GenderEnum genderEnum, String userId) {
    _healthProfile.gender = genderEnum;
    _sharedPreferencesRepo.storeSerializable<HealthProfile>(_healthProfile,
        authId: userId);
  }

  void changeUserBirthday(DateTime birthday, String userId) {
    _healthProfile.birthday = birthday;
    _sharedPreferencesRepo.storeSerializable<HealthProfile>(_healthProfile,
        authId: userId);
  }

  Future<bool> loadProfile(AuthProfile userProfile) async {
    return _sharedPreferencesRepo
        .readSerialized<HealthProfile>(authId: userProfile.id)
        .then((HealthProfile? loadedHealthProfile) {
      bool userDidLoad = loadedHealthProfile != null;
      if (userDidLoad) {
        _healthProfile.height = loadedHealthProfile.height;
        _healthProfile.weight = loadedHealthProfile.weight;
        _healthProfile.gender = loadedHealthProfile.gender;
        _healthProfile.birthday = loadedHealthProfile.birthday;
      }
      return userDidLoad;
    });
  }

  Future<void> storeUploadProfile(AuthProfile authProfile) async {
    return _userInfoRepository.uploadUserProfile(authProfile, _healthProfile);
  }

  void clearData() {
    _healthProfile.height = null;
    _healthProfile.weight = null;
    _healthProfile.gender = null;
    _healthProfile.birthday = null;
  }
}
