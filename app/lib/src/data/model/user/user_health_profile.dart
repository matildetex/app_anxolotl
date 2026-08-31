import 'package:anxolotl_app/src/data/services/health_profile/utils.dart';
import 'package:anxolotl_app/src/data/data_acces/dto/local_storage/preferences_serializable.dart';

class HealthProfile extends PreferencesSerializable<HealthProfile> {
  //IN cm
  late int? height;
  //In KG
  late int? weight;
  late GenderEnum? gender;
  late DateTime? birthday;

  HealthProfile.empty() {
    height = null;
    weight = null;
    gender = null;
    birthday = null;
  }

  HealthProfile(
      {required this.height,
      required this.weight,
      required this.gender,
      required this.birthday});

  @override
  String serialize() {
    return [
      height.toString(),
      weight.toString(),
      gender?.index,
      birthday?.toString()
    ].join(PreferencesSerializable.SEPARATOR);
  }
}

class HealthProfileFactory
    implements PreferencesSerializableFactory<HealthProfile> {
  @override
  HealthProfile newInstance(String serializedStr) {
    List<String> serializedStrArr =
        serializedStr.split(PreferencesSerializable.SEPARATOR);
    return HealthProfile(
        height: serializedStrArr[0].contains("null")
            ? null
            : int.parse(serializedStrArr[0]),
        weight: serializedStrArr[1].contains("null")
            ? null
            : int.parse(serializedStrArr[1]),
        gender: GenderEnum.values[int.parse(serializedStrArr[2])],
        birthday: DateTime.parse(serializedStrArr[3]));
  }
}
