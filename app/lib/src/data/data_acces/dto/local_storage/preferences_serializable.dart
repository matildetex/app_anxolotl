import 'package:anxolotl_app/src/data/model/user/user_health_profile.dart';
import 'package:anxolotl_app/src/data/model/user/user_profile.dart';
import 'package:anxolotl_app/src/data/services/bluetooth/bluetooth_dev.dart';

abstract class PreferencesSerializable<T> {
  static const String SEPARATOR = "--";

  static Map<Type, PreferencesSerializableFactory> factoriesMap = {
    BluetoothDev: BluetoothDevFactory(),
    HealthProfile: HealthProfileFactory(),
    AuthProfile: AuthProfileFactory(),
  };

  static Map<Type, String> serializeNamesMap = {
    BluetoothDev: "blDevice",
    HealthProfile: "healthProfile",
    AuthProfile: "authProfile",
  };

  String serialize();
}

abstract class PreferencesSerializableFactory<
    T extends PreferencesSerializable> {
  T newInstance(String serializedStr);
}
