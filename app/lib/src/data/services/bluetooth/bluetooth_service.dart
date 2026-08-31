import 'dart:async';

import 'package:anxolotl_app/src/data/services/bluetooth/bluetooth_dev.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:permission_handler/permission_handler.dart';

class BluetoothService {
  /// Utilizado para Bluetooth Classic (Mantido como estava)
  late final FlutterBluetoothSerial _flutterBluetoothClassic;

  BluetoothService() {
    _flutterBluetoothClassic = FlutterBluetoothSerial.instance;
  }

  Future<void> askForBluetoothPermissions() async {
    // No Android 12+, precisamos especificamente de Scan e Connect
    Map<Permission, PermissionStatus> statuses = await [
      Permission.bluetooth,
      Permission.bluetoothScan,
      Permission.bluetoothConnect,
      Permission.locationWhenInUse,
    ].request();

    if (statuses[Permission.bluetoothScan]!.isDenied) {
      // Opcional: Tratar negação
    }
  }

  Stream<BluetoothDev> scanDevices(int timeoutInSeconds) {
    StreamController<BluetoothDev> streamBuilder = StreamController();

    // 1. SCAN BLUETOOTH CLASSIC (A API do flutter_bluetooth_serial não mudou)
    _flutterBluetoothClassic.startDiscovery().listen((BluetoothDiscoveryResult scanResult) {
      if (scanResult.device.name != null) {
        streamBuilder.add(BluetoothDev.android(
            macId: scanResult.device.address,
            name: scanResult.device.name!,
            blType: BluetoothCommunicationType.BTH));
      }
    });

    // 2. SCAN BLUETOOTH LOW ENERGY (Nova API FlutterBluePlus)
    
    // Escutamos os resultados conforme eles chegam
    var subscription = FlutterBluePlus.scanResults.listen((results) {
      for (ScanResult r in results) {
        String deviceName = r.advertisementData.localName.isNotEmpty 
        ? r.advertisementData.localName 
        : (r.device.localName.isNotEmpty ? r.device.localName : r.device.remoteId.str);

        streamBuilder.add(BluetoothDev.android(
        uuid: r.device.remoteId.str, 
        name: deviceName,
        blType: BluetoothCommunicationType.BLE));
      }
    });

    // Iniciamos o scan de fato
    FlutterBluePlus.startScan(timeout: Duration(seconds: timeoutInSeconds));

    // Garantir que a subscription seja limpa quando o timeout acabar
    Future.delayed(Duration(seconds: timeoutInSeconds)).then((_) {
      subscription.cancel();
      if (!streamBuilder.isClosed) streamBuilder.close();
    });

    return streamBuilder.stream;
  }

  Future<void> stopScanning() async {
    // Classic
    await _flutterBluetoothClassic.cancelDiscovery();
    // BLE
    await FlutterBluePlus.stopScan();
  }

  Future<void> disconnectAll() async {
    // .connectedDevices agora é uma lista síncrona
    final connected = await FlutterBluePlus.connectedDevices;
    for (var device in connected) {
      await device.disconnect();
    }
  }

  // .isOn -> adapterState
  Future<bool> isBluetoothOn() async {
    return FlutterBluePlus.adapterState == BluetoothAdapterState.on;
  }
}