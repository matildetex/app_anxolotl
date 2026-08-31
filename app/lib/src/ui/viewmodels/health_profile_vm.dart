import 'package:anxolotl_app/src/data/model/user/user_profile.dart';
import 'package:anxolotl_app/src/data/services/authentication/authentication_service.dart';
import 'package:anxolotl_app/src/data/services/health_profile/health_profile_service.dart';
import 'package:anxolotl_app/src/data/services/health_profile/utils.dart';
import 'package:anxolotl_app/src/lang/anxolotl_localizations.dart';
import 'package:anxolotl_app/src/ui/datatypes/picker_entry_datatype.dart';
import 'package:flutter/material.dart';

class HealthProfileViewModel extends ChangeNotifier {
  final HealthProfileService _healthProfileService;
  final AuthenticationService _authenticationService;
  late final NumberPickerEntryDatatype _weightPickerEntryType;
  late final NumberPickerEntryDatatype _heightPickerEntryType;
  late final DatePickerEntryDatatype _birthdayPickerEntryType;
  late final StringPickerEntryDatatype _genderPickerEntryType;
  bool _valuesChanged = false;

  HealthProfileViewModel(
      this._healthProfileService, this._authenticationService) {
    _weightPickerEntryType = NumberPickerEntryDatatype(ValueInterval(30, 250),
        _healthProfileService.getHealthProfile().height, "kg");
    _heightPickerEntryType = NumberPickerEntryDatatype(ValueInterval(50, 220),
        _healthProfileService.getHealthProfile().weight, "cm");
    _birthdayPickerEntryType = DatePickerEntryDatatype(
        ValueInterval(DateTime.utc(1910), DateTime.now()),
        _healthProfileService.getHealthProfile().birthday);
    _genderPickerEntryType = StringPickerEntryDatatype([
      StringPickerValue(
          code: 0,
          name: GenderEnum.male.toString(),
          translateName: (BuildContext context) =>
              LocalizationsUtil.l10n(context).maleWord),
      StringPickerValue(
          code: 1,
          name: GenderEnum.female.toString(),
          translateName: (BuildContext context) =>
              LocalizationsUtil.l10n(context).femaleWord),
      StringPickerValue(
          code: 2,
          name: GenderEnum.other.toString(),
          translateName: (BuildContext context) =>
              LocalizationsUtil.l10n(context).otherWord)
    ]);
    _genderPickerEntryType.setCurrValue(
        _healthProfileService.getHealthProfile().gender?.index);
  }

  Future<HealthProfileViewModel> init() async {
    AuthProfile? authProfile = _authenticationService.getUserProfile();
    if (authProfile == null) return this;
    bool userDidLoad = await _healthProfileService.loadProfile(authProfile);
    if (!userDidLoad) return this;
    _weightPickerEntryType.currValue =
        _healthProfileService.getHealthProfile().weight;
    _heightPickerEntryType.currValue =
        _healthProfileService.getHealthProfile().height;
    _birthdayPickerEntryType.currValue =
        _healthProfileService.getHealthProfile().birthday;
    _genderPickerEntryType
        .setCurrValue(_healthProfileService.getHealthProfile().gender!.index);
    notifyListeners();
    return this;
  }

  void setUserHeight(int height) {
    _healthProfileService.changeUserHeight(
        height, _authenticationService.getUserProfile()!.id);
    _heightPickerEntryType.currValue = height;
    _valuesChanged = true;
    notifyListeners();
  }

  void setUserWeight(int weight) {
    _healthProfileService.changeUserWeight(
        weight, _authenticationService.getUserProfile()!.id);
    _weightPickerEntryType.currValue = weight;
    _valuesChanged = true;
    notifyListeners();
  }

  void setUserGender(String genderName, BuildContext context) {
    if (genderName.isEmpty) return;
    StringPickerValue pickedValue = _genderPickerEntryType.values.firstWhere(
        (StringPickerValue element) =>
            element.translateName(context) == genderName);
    _healthProfileService.changeUserGender(GenderEnum.values[pickedValue.code!],
        _authenticationService.getUserProfile()!.id);
    _genderPickerEntryType.setCurrValue(pickedValue.code!);
    _valuesChanged = true;
    notifyListeners();
  }

  void setUserBirthday(DateTime dateTime) async {
    _healthProfileService.changeUserBirthday(
        dateTime, _authenticationService.getUserProfile()!.id);
    _birthdayPickerEntryType.currValue = dateTime;
    _valuesChanged = true;
    notifyListeners();
  }

  void updateValues() async {
    _weightPickerEntryType.currValue =
        _healthProfileService.getHealthProfile().weight;
    _heightPickerEntryType.currValue =
        _healthProfileService.getHealthProfile().height;
    _birthdayPickerEntryType.currValue =
        _healthProfileService.getHealthProfile().birthday;
    _genderPickerEntryType.setCurrValue(
        _healthProfileService.getHealthProfile().gender?.index);
    notifyListeners();
  }

  NumberPickerEntryDatatype getUserWeight() => _weightPickerEntryType;

  NumberPickerEntryDatatype getUserHeight() => _heightPickerEntryType;

  DatePickerEntryDatatype getUserBirthday() => _birthdayPickerEntryType;

  StringPickerEntryDatatype getUserGender() => _genderPickerEntryType;

  bool isUserDataInitialized() =>
      _healthProfileService.getHealthProfile().gender != null &&
      _healthProfileService.getHealthProfile().birthday != null;

  void deactivatePageOperations() {
    if (_valuesChanged) {
      _healthProfileService
          .storeUploadProfile(_authenticationService.getUserProfile()!);
    }
    _valuesChanged = false;
  }
}
