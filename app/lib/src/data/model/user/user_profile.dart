import 'package:anxolotl_app/src/data/data_acces/dto/local_storage/preferences_serializable.dart';
import 'package:anxolotl_app/src/data/services/authentication/iauthentication_provider.dart';

class AuthProfile extends PreferencesSerializable<AuthProfile> {
  late final AuthenticationProviderName authenticationProviderName;
  late final String email;
  late final String id;
  late final String fullName;

  AuthProfile(
      {required this.authenticationProviderName,
      required this.email,
      required this.id,
      required this.fullName});

  AuthProfile.empty();

  @override
  String serialize() {
    return [authenticationProviderName.index, email, id, fullName]
        .join(PreferencesSerializable.SEPARATOR);
  }
}

class AuthProfileFactory
    implements PreferencesSerializableFactory<AuthProfile> {
  @override
  AuthProfile newInstance(String serializedStr) {
    List<String> serializedStrArr =
        serializedStr.split(PreferencesSerializable.SEPARATOR);
    return AuthProfile(
      authenticationProviderName:
          AuthenticationProviderName.values[int.parse(serializedStrArr[0])],
      email: serializedStrArr[1],
      id: serializedStrArr[2],
      fullName: serializedStrArr[3],
    );
  }
}
