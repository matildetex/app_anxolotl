import 'dart:async';

import 'package:anxolotl_app/src/data/model/entities/common/idevice.dart';
import 'package:anxolotl_app/src/data/model/entities/common/sensor/sensor.dart';
import 'package:anxolotl_app/src/data/model/entities/common/sensor_info.dart';
import 'package:anxolotl_app/src/data/model/entities/common/bit_utils.dart';
import 'package:anxolotl_app/src/data/model/entities/hband/hband_device.dart';
import 'package:anxolotl_app/src/data/model/entities/hband/hband_hardware_ids.dart';
import 'package:anxolotl_app/src/data/model/entities/hband/sensors/hband_sensor.dart';
import 'package:anxolotl_app/src/data/services/bluetooth/bluetooth_dev.dart';
import 'package:anxolotl_app/src/data/services/device/contracts/acquisition_objects.dart';
import 'package:anxolotl_app/src/data/services/device/contracts/idevice_controller.dart';
import 'package:anxolotl_app/src/data/services/device/device_service.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class HBandController extends IDeviceController<AcquisitionInfo, IHBandDevice> {
  @override
  late final IHBandDevice device = IHBandDevice();
  
  BluetoothDevice? _connectedDevice;
  final Map<String, _MeasuringToken> _currentMeasuringTokensMap = {};
  final Duration bufferTime = const Duration(milliseconds: 500);

  @override
  Future<bool> connectDevice(BluetoothDev bluetoothDev) async {
    // Para o scan se já estiver rodando
    if (FlutterBluePlus.isScanningNow) {
      await FlutterBluePlus.stopScan();
    }

    // Desconecta dispositivos antigos para evitar conflitos
    var devices = await FlutterBluePlus.connectedDevices;
    for (var element in devices) {
      await element.disconnect();
    }

    Completer<void> scanCompleter = Completer();
    
    // Escuta os resultados do scan
    var subscription = FlutterBluePlus.scanResults.listen((results) async {
      for (ScanResult r in results) {
        // .id mudou para .remoteId
        if (r.device.remoteId.toString() == bluetoothDev.getIdentifier()) {
          _connectedDevice = r.device;
          await FlutterBluePlus.stopScan();
          if (!scanCompleter.isCompleted) scanCompleter.complete();
        }
      }
    });

    // Inicia o scan
    await FlutterBluePlus.startScan(timeout: const Duration(seconds: 10));

    // Aguarda encontrar o device ou o timeout de 10s
    await Future.any([
      scanCompleter.future,
      Future.delayed(const Duration(seconds: 10))
    ]);
    
    await subscription.cancel();

    if (_connectedDevice == null) {
      return false;
    }

    // Conecta ao dispositivo encontrado
    await _connectedDevice!.connect(autoConnect: false);

    // Retorna true se houver dispositivos conectados na lista global
    return (await FlutterBluePlus.connectedDevices).isNotEmpty;
  }

  Future<void> _initContinuousBandMode() async {
    BluetoothCharacteristic characteristic = await _getCharacteristic(
        HBandServices.PULSEON_SERVICE,
        HBandCharacteristics
            .pulseOnServiceCharacteristics.OPERATIONAL_PARAMETERS);

    List<int> readValue = await characteristic.read();

    print("### continuous");

    readValue = readValue
            .setBitData(0, 1, 0x1)
            .setBitData(1, 3, 0x05) 
            .setBitData(4, 8, 0x47) 
            .setBitData(12, 8, 0x13) 
            .setBitData(20, 16, 30000);

    await characteristic.write(readValue);
  }

  Future<void> _initDiscreteBandMode([Duration? samplingRate]) async {
    BluetoothCharacteristic characteristic = await _getCharacteristic(
        HBandServices.PULSEON_SERVICE,
        HBandCharacteristics
            .pulseOnServiceCharacteristics.OPERATIONAL_PARAMETERS);

    List<int> readValue = await characteristic.read();

    if (samplingRate == null ||
        samplingRate.inSeconds > 5 * 60 ||
        samplingRate.inSeconds < 30) {
      samplingRate = const Duration(seconds: 30);
    }

    readValue = readValue
            .setBitData(1, 3, 0x07) 
            .setBitData(4, 8, 0x45) 
            .setBitData(12, 8, 0x13) 
            .setBitData(52, 16, 60) 
            .setBitData(100, 1, 0x1);

    await characteristic.write(readValue);
  }

  @override
  Future<bool> configureBand(MeasuringMode measuringMode,
      {Duration? samplingRate}) async {
    switch (measuringMode) {
      case MeasuringMode.DISCRETE:
        await _initDiscreteBandMode(samplingRate);
        return true;
      case MeasuringMode.CONTINUOUS:
        await _initContinuousBandMode();
        return true;
      default:
        return false;
    }
    return false;
  }

  @override
  Future<Iterable<AcquisitionStream>> startAcquisition(
      AcquisitionInfo bitalinoObject) async {
    List<AcquisitionStream> acquisitionStreams = [];

    await Future.forEach(bitalinoObject.sensors, (Sensor sensor) async {
      HBandSensor hbandSensor = device.getSensorModule(sensor);

      print("[HBAND-CONTROLLER] - starting sensor ${sensor.name}");

      BluetoothCharacteristic readCharacteristic = await _getCharacteristic(
          hbandSensor.serviceName, hbandSensor.characteristicName);

      await readCharacteristic.setNotifyValue(true);
      await Future.delayed(bufferTime);

      DateTime starting = DateTime.now();

      if (!_currentMeasuringTokensMap.containsKey(sensor.name)) {
        AcquisitionStream acquisitionStream =
            AcquisitionStream(sensor, StreamController<AcquisitionReturn>());

        // .value.listen mudou para .onValueReceived.listen
        StreamSubscription<List<int>> listeningCharacteristicSub =
            readCharacteristic.onValueReceived.listen((value) async {
          if (value.isEmpty) return;
          Map<String, dynamic> parsedResult =
              hbandSensor.parseSensorValue(value).toMap();

          print(
              "[HBAND-CONTROLLER] Measurement $sensor - ${DateTime.now()} values = $parsedResult");

          if (acquisitionStream.isPaused()) {
            if (_currentMeasuringTokensMap.containsKey(sensor.name)) {
              await stopAcquisition(sensor);
              print(
                  "[HBAND-CONTROLLER] ACQUISITION FROM $sensor - $starting WILL STOP");
            }
          } else {
            acquisitionStream.getStreamController().add(AcquisitionReturn(
                sensorName: sensor.name, values: parsedResult));
          }
        });

        _currentMeasuringTokensMap[sensor.name] = _MeasuringToken(sensor,
            readCharacteristic, listeningCharacteristicSub, acquisitionStream);

        acquisitionStreams.add(acquisitionStream);
      } else {
        _MeasuringToken measuringToken =
            _currentMeasuringTokensMap[sensor.name]!;
        measuringToken.listeningSubscription.resume();
        measuringToken.acquisitionStream.resume();

        acquisitionStreams.add(measuringToken.acquisitionStream);
      }

      print("[HBAND-CONTROLLER] - Finished sensor ${sensor.name}");
    });

    return acquisitionStreams;
  }

  Future<BluetoothCharacteristic> _getCharacteristic(
      String serviceName, String characteristicName) async {
    // discoverServices agora retorna a lista diretamente
    List<BluetoothService> services = await _connectedDevice!.discoverServices();
    
    BluetoothService blServiceResult = services.firstWhere(
            (blService) => blService.uuid.toString().toLowerCase() == serviceName.toLowerCase());

    BluetoothCharacteristic readCharacteristic = blServiceResult.characteristics
        .firstWhere((characteristic) =>
            characteristic.uuid.toString().toLowerCase() == characteristicName.toLowerCase());
    return readCharacteristic;
  }

  // .id.id mudou para .remoteId.str
  @override
  String getDeviceIdentifier() => _connectedDevice?.remoteId.str ?? "";

  @override
  Future<bool> stopAcquisition(Sensor sensor) async {
    if (!(_currentMeasuringTokensMap.containsKey(sensor.name))) return false;
    _MeasuringToken measuringToken = _currentMeasuringTokensMap[sensor.name]!;

    _currentMeasuringTokensMap[sensor.name]!.listeningSubscription.pause();
    bool notificationChanged = false;
    if (!_currentMeasuringTokensMap[sensor.name]!.acquisitionStream.isPaused()) {
      notificationChanged =
          await measuringToken.characteristic.setNotifyValue(false);
    }
    
    return notificationChanged;
  }

  @override
  Future<void> setStandby() async {
    BluetoothCharacteristic characteristic = await _getCharacteristic(
        HBandServices.PULSEON_SERVICE,
        HBandCharacteristics
            .pulseOnServiceCharacteristics.OPERATIONAL_PARAMETERS);

    List<int> readValue = await characteristic.read();

    readValue = readValue
        .setBitData(20, 16, 0xEA60) 
        .setBitData(36, 16, 0xEA60) 
        .setBitData(52, 16, 60); 

    await characteristic.write(readValue);
  }

  @override
  Future<bool> disconnectDevice() async {
    if (_connectedDevice == null) return false;
    
    for (var token in _currentMeasuringTokensMap.values) {
      await stopAcquisition(token.sensor);
    }
    
    await _connectedDevice!.disconnect();
    _connectedDevice = null;
    return true;
  }

  @override
  bool isDeviceConnected() {
    return _connectedDevice != null;
  }

  @override
  bool isMeasuring() {
    return _currentMeasuringTokensMap.isNotEmpty;
  }

  @override
  void changeDeviceConfig(IDeviceConfig deviceConfig) =>
      device.setConfig(deviceConfig as IHBandConfig);

  @override
  Iterable<IDeviceConfig> getAllDeviceConfigs() => device.getConfigs();

  @override
  Iterable<Sensor> getDeviceSensors() => device.getDeviceSensors();

  @override
  SensorMeasurementInfo getSensorInfo(Sensor sensor) {
    HBandSensor hbandSensorModule = device.getSensorModule(sensor);
    return SensorMeasurementInfo(
        hbandSensorModule.measurementInfo, hbandSensorModule.sensorFrequency);
  }

  @override
  IDeviceConfig getDeviceConfig() => device.currentConfig;

  @override
  Future<List<int>> getBatteryLevel() async {
    BluetoothCharacteristic characteristic = await _getCharacteristic(
        HBandServices.BATTERY_SERVICE,
        BatteryServiceCharacteristics().BATTERY_PERCENTAGE);

    List<int> result = await characteristic.read();
    print("battery result $result");
    return result;
  }
}

class _MeasuringToken {
  final Sensor sensor;
  final BluetoothCharacteristic characteristic;
  final StreamSubscription<List<int>> listeningSubscription;
  final AcquisitionStream acquisitionStream;

  _MeasuringToken(this.sensor, this.characteristic, this.listeningSubscription,
      this.acquisitionStream);
}