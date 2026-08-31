import 'dart:async';

import 'package:anxolotl_app/src/data/services/authentication/authentication_service.dart';
import 'package:anxolotl_app/src/data/services/bluetooth/bluetooth_dev.dart';
import 'package:anxolotl_app/src/data/services/bluetooth/bluetooth_service.dart';
import 'package:anxolotl_app/src/data/services/device/device_service.dart';
import 'package:anxolotl_app/src/data/services/foreground_operations/foreground_operations_service.dart';
import 'package:anxolotl_app/src/data/services/foreground_operations/operations/measurement_background_operation.dart';
import 'package:flutter/cupertino.dart';

class BluetoothViewModel extends ChangeNotifier {
  final DeviceService _deviceService;
  final BluetoothService _bluetoothService;
  final AuthenticationService _authenticationService;

  bool _isScanning = false;
  int? _batteryLevel;

  final ForegroundOperationsService
      _foregroundOperationsServiceOperationsService;
  final MeasurementBackgroundOperation dmbo = MeasurementBackgroundOperation();

  String _currDeviceName = "";
  String _currDeviceMacAddress = "";

  //BluetoothViewModel(this._bluetoothService,this._deviceService, this._foregroundOperationsServiceOperationsService, this._sharedPreferencesService) {
  BluetoothViewModel(this._bluetoothService, this._authenticationService,
      this._deviceService, this._foregroundOperationsServiceOperationsService) {
    _deviceService
        .loadBluetoothDev()
        .then((BluetoothDev? storedBluetoothDev) async {
      if (storedBluetoothDev == null) return;
      print("Stored bl dev: ${storedBluetoothDev.serialize()}");

      /**
       * Case for notification running in the background
       */
      if (await _foregroundOperationsServiceOperationsService.isRunning()) {
        _currDeviceMacAddress = storedBluetoothDev.getIdentifier();
        _currDeviceName = storedBluetoothDev.name;
        _batteryLevel = storedBluetoothDev.batteryValue;
        return;
      }

      _bluetoothService.disconnectAll();
      bool foundDevice = false;
      Stream<BluetoothDev> scanDevicesStream =
          scanDevices(timeOutInSeconds: 10).takeWhile((_) => !foundDevice);
      scanDevicesStream
          .firstWhere((blDevice) =>
              blDevice.getIdentifier() == storedBluetoothDev.getIdentifier())
          .then((bluetoothDev) => connectDevice(bluetoothDev))
          .whenComplete(() {
        foundDevice = true;
        stopScanning();
      });
    });
  }

  bool isConnected() => getCurrDeviceIdentifier().isNotEmpty;

  //TODO poderá ser de outro vm :)
  Future<void> connectDevice(BluetoothDev bluetoothDev,
      {bool newConnection = false}) async {
    print("##### Tring to connect device");
    if (_currDeviceMacAddress.isEmpty) {
      await stopScanning();
      await _deviceService
          .connectToDevice(bluetoothDev)
          .then((bool didConnect) async {
        if (didConnect) {
          //await _sharedPreferencesService.storeSerializable<BluetoothDev>(bluetoothDev);
          //Only this time, while the device is still connected
          await _foregroundOperationsServiceOperationsService
              .startForegroundTask(dmbo);
        }
      });
      _batteryLevel = bluetoothDev.batteryValue;
      _currDeviceMacAddress = _deviceService.getDeviceIdentifier();
      _currDeviceName = _deviceService.getDeviceName();
      if (newConnection) {
        _deviceService
            .uploadBluetoothDev(_authenticationService.getUserProfile()!.id);
      }

      await _deviceService.disconnectDevice(removeFromMemory: false);

      notifyListeners();
    }
  }

  String getCurrDeviceIdentifier() {
    return _currDeviceName;
  }

  Future<void> disconnectDevice() async {
    _currDeviceName = "";
    _currDeviceMacAddress = "";
    _foregroundOperationsServiceOperationsService
        .stopForegroundTask()
        .then((value) {
      _bluetoothService.disconnectAll();
      _deviceService.disconnectDevice(removeFromMemory: true);
      notifyListeners();
    });
  }

  Stream<BluetoothDev> scanDevices(
      {List<BluetoothDev>? containerList, int timeOutInSeconds = 30}) {
    _isScanning = true;
    notifyListeners();
    Future.delayed(Duration(seconds: timeOutInSeconds))
        .whenComplete(() => stopScanning());
    Stream<BluetoothDev> deviceScanStream =
        _bluetoothService.scanDevices(timeOutInSeconds);
    if (containerList != null) {
      deviceScanStream.listen((event) {
        containerList.add(event);
        notifyListeners();
      });
    }
    return deviceScanStream;
  }

  /// If the widget is closing, notifyListeners can not be called,
  /// since the widget itself is being wiped
  Future<void> stopScanning({bool closingWidget = false}) async {
    _isScanning = false;
    if (!closingWidget) notifyListeners();
    await _bluetoothService.stopScanning();
  }

  void update() => notifyListeners();

  Future<void> updateDeviceBatteryLevel() async {
    /**
     * ONLY TO BE USED AFTER THE DEVICE NOTIFICATION STARTED
     */
    await _deviceService.reloadStorage();
    _batteryLevel = await _deviceService
        .loadBluetoothDev()
        .then((value) => value?.batteryValue);
    notifyListeners();
  }

  bool isScanning() => _isScanning;
  String? getBatteryLevel() =>
      _batteryLevel != null ? _batteryLevel.toString() : "?";

  Future<bool> isBluetoothOn() => _bluetoothService.isBluetoothOn();

  @override
  void dispose() {
    //Avoids bluetooth problems
    _deviceService.disconnectDevice(removeFromMemory: false);
  }
}
