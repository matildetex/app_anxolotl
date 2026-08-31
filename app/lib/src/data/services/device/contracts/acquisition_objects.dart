import 'dart:async';

import 'package:anxolotl_app/src/data/model/entities/common/sensor/sensor.dart';
import 'package:anxolotl_app/src/data/model/entities/common/sensor/sensor_frequency.dart';

/// *
/// Used to identify the information to measure, and data which will be measured
class AcquisitionInfo {
  final Iterable<Sensor> sensors;
  final SensorFrequency? frequency;
  //final String measuredUnits;

  //AcquisitionInfo({required this.sensors, this.frequency, String? unit}): this.measuredUnits = unit ?? sensor.measuredUnit;
  AcquisitionInfo({required this.sensors, this.frequency});
}

/// *getResults
/// Returning Object from the measured streams
class AcquisitionReturn {
  final Map<String, dynamic> values;
  late String sensorName;

  AcquisitionReturn({required this.values, required this.sensorName});
}

/// *
/// Auxiliary Return Stream for results
class AcquisitionStream {
  final Sensor sensor;
  final StreamController<AcquisitionReturn> _streamController;
  final Stream<AcquisitionReturn> receiverStream;
  bool _paused = false;

  AcquisitionStream(this.sensor, this._streamController)
      : receiverStream = _streamController.stream.asBroadcastStream();

  Stream<AcquisitionReturn> getStream() => receiverStream;

  Future<bool> close() async {
    await _streamController.close();
    //todo ADICIONAR AQUI O FECHO DO LISTEN GENÉRICO, assim permite evityar erros
    return _streamController.isClosed;
  }

  StreamController<AcquisitionReturn> getStreamController() =>
      _streamController;

  void pause() => _paused = true;

  void resume() => _paused = false;

  bool isPaused() => _paused;

  bool isClosed() => _streamController.isClosed;
}
