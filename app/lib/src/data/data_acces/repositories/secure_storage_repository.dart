import 'package:anxolotl_app/src/data/data_acces/dto/local_storage/preferences_serializable.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageRepository {
  final FlutterSecureStorage _storage;
  final String measuringModeStr = "measuringMode";

  SecureStorageRepository(this._storage);

  Future<void> storeSerializable<T extends PreferencesSerializable>(
      T preferencesSerializable,
      {String authId = ""}) async {
    await _storage.write(
        key: authId + PreferencesSerializable.serializeNamesMap[T]!,
        value: preferencesSerializable.serialize());
  }

  Future<T?> readSerialized<T extends PreferencesSerializable>(
      {String authId = ""}) async {
    PreferencesSerializableFactory<PreferencesSerializable>? factory =
        PreferencesSerializable.factoriesMap[T];
    String? result = await _storage.read(
        key: authId + PreferencesSerializable.serializeNamesMap[T]!);
    if (result == null || factory == null) return null;

    return factory.newInstance(result) as T;
  }

  Future<void> removeSerialized<T extends PreferencesSerializable>() async {
    await _storage.delete(key: PreferencesSerializable.serializeNamesMap[T]!);
  }
}
