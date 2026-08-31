import 'package:anxolotl_app/src/data/data_acces/dto/local_storage/preferences_serializable.dart';

enum BluetoothCommunicationType { BTH, BLE }

///BLuetooth device custom class
class BluetoothDev extends PreferencesSerializable<BluetoothDev> {
  late final String name;
  late final String? uuid;
  late final String? macId;
  late final BluetoothCommunicationType blType;
  late int batteryValue = -1;

  BluetoothDev.android(
      {this.name = "", this.macId, this.uuid, required this.blType});

  BluetoothDev.ios({this.name = "", required this.uuid, required this.blType});

  BluetoothDev.fromSerializable(
      this.name, this.macId, this.uuid, this.blType, this.batteryValue);

  BluetoothDev.empty();

  String getIdentifier() {
    if (macId != null && macId!.isNotEmpty) {
      return macId!;
    } else {
      return uuid!;
    }
  }

  @override
  String serialize() {
    return [
      name,
      uuid ?? "",
      macId ?? "",
      blType.index.toString(),
      batteryValue.toString()
    ].join(PreferencesSerializable.SEPARATOR);
  }
}

class BluetoothDevFactory
    implements PreferencesSerializableFactory<BluetoothDev> {
  @override
  BluetoothDev newInstance(String serializedStr) {
    List<String> serializedStrArr =
        serializedStr.split(PreferencesSerializable.SEPARATOR);
    return BluetoothDev.fromSerializable(
        serializedStrArr[0],
        serializedStrArr[1],
        serializedStrArr[2],
        BluetoothCommunicationType.values[int.tryParse(serializedStrArr[3])!],
        int.tryParse(serializedStrArr[4])!);
  }
}
