import 'package:anxolotl_app/src/data/services/device/device_service.dart';
import 'package:anxolotl_app/src/data/data_acces/dto/local_storage/preferences_serializable.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesRepository {
  final SharedPreferences _prefs;
  final String measuringModeStr = "measuringMode";

  SharedPreferencesRepository(this._prefs);

  Future<bool> storeSerializable<T extends PreferencesSerializable>(
      T preferencesSerializable) async {
    return await _prefs.setString(PreferencesSerializable.serializeNamesMap[T]!,
        preferencesSerializable.serialize());
  }

  T? readSerialized<T extends PreferencesSerializable>() {
    PreferencesSerializableFactory<PreferencesSerializable>? factory =
        PreferencesSerializable.factoriesMap[T];
    print("Existing certs ${_prefs.getKeys()}");
    String? result =
        _prefs.getString(PreferencesSerializable.serializeNamesMap[T]!);
    if (result == null || factory == null) return null;

    return factory.newInstance(result) as T;
  }

  Future<bool> removeSerialized<T extends PreferencesSerializable>() async {
    return await _prefs.remove(PreferencesSerializable.serializeNamesMap[T]!);
  }

  Future<void> reloadStorage() => _prefs.reload();

  Future<void> storeMeasuringMode(MeasuringMode measuringMode) async {
    await _prefs.setInt(measuringModeStr, measuringMode.index);
  }

  MeasuringMode? retrieveMeasuringMode() {
    int? measuringModeIndex = _prefs.getInt(measuringModeStr);
    if (measuringModeIndex == null) return null;
    return MeasuringMode.values.elementAt(measuringModeIndex);
  }
}
