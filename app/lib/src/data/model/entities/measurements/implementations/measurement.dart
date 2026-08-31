import 'package:anxolotl_app/src/data/model/entities/common/sensor/sensor.dart';
import 'package:anxolotl_app/src/data/model/entities/measurements/implementations/measurement_data.dart';
import 'package:anxolotl_app/src/data/model/entities/measurements/implementations/measurement_row.dart';
import 'package:anxolotl_app/src/data/model/entities/measurements/implementations/measurement_state.dart';
import 'package:anxolotl_app/src/data/model/entities/measurements/measurement_input_type.dart';
import 'package:anxolotl_app/src/data/services/device/contracts/acquisition_objects.dart';
import 'package:anxolotl_app/src/data/services/foreground_operations/operations/tokens.dart';

//Todo tem de estender de um Measurmeent Abstract para permitir insercao manual
class Measurement {
  late final MeasurementType _measurementType;
  late final MeasurementData _measurementData;

  late final int? _amountOfSamples;
  late final Duration? _durationOfMeasurement;
  late final DateTime startingTime;

  void _init(String sensorName) {
    /**
     * Setting the name of the measurement, to guarantee it is unique
     */
    DateTime currDatetime = DateTime.now();
    startingTime = currDatetime;
    currDatetime
        .subtract(Duration(milliseconds: currDatetime.millisecondsSinceEpoch));
    _measurementData = MeasurementData(sensorName, _measurementType);
  }

  Measurement.Discrete() {
    _measurementType = MeasurementType.DISCRETE;

    _amountOfSamples = 1;
    _durationOfMeasurement = null;
  }

  /// One of the arguments (durationOfSampling and numberOfSamples) must be set,
  /// or else it is assumed this a continuous measurement without predefined ending
  Measurement.Continuous({
    int? numberOfSamples,
    Duration? durationOfMeasurement,
  }) {
    _measurementType = MeasurementType.CONTINUOUS;

    if (numberOfSamples != null) {
      _amountOfSamples = numberOfSamples;
      _durationOfMeasurement = null;
    } else if (durationOfMeasurement != null) {
      _durationOfMeasurement = durationOfMeasurement;
      _amountOfSamples = null;
    } else {
      throw Exception("Please read the documentation");
    }
  }

  Measurement.CopyFromExisting(Sensor sensor, Measurement oldMeasurement) {
    _measurementType = oldMeasurement._measurementType;
    _amountOfSamples = oldMeasurement._amountOfSamples;
    _durationOfMeasurement = oldMeasurement._durationOfMeasurement;
    _init(sensor.name);
  }

  /// Finishes when all of the elements needed from the stream are processed
  Future<bool> startMeasuring(Stream<AcquisitionReturn> sampledValueStream,
      CancellationToken cancellationToken) async {
    _measurementData.setMeasurementState(MeasurementState.MEASURING);

    Stream<AcquisitionReturn> adaptedStream = sampledValueStream;
    int counter = 0;
    if (_amountOfSamples != null) {
      adaptedStream = sampledValueStream.takeWhile((AcquisitionReturn element) {
        bool returnVal =
            counter++ < _amountOfSamples! && !cancellationToken.isCancelled;
        return returnVal;
      });
    } else if (_durationOfMeasurement != null) {
      DateTime limitTime = DateTime.now().add(_durationOfMeasurement!);
      adaptedStream = sampledValueStream.takeWhile((element) =>
          DateTime.now().compareTo(limitTime) < 1 &&
          !cancellationToken.isCancelled);
    }

    await adaptedStream.forEach((AcquisitionReturn acquisitionReturnObject) {
      //After creation, add the values
      print("[MEASUREMENT-ADD] ${acquisitionReturnObject.sensorName}");
      _measurementData.addNewResultRow(
          DateTime.now(), acquisitionReturnObject.values);
    }).then((value) =>
        _measurementData.setMeasurementState(MeasurementState.FINISHED));

    return true;
  }

  void finish() {
    if (_measurementData.getMeasurementState() != MeasurementState.FINISHED) {
      throw Exception("EXCEPTION -Measurement not finished");
    }
    print('Measurement finished');
  }

  List<MeasurementRow> getResults() {
    return _measurementData.getResults();
  }

  String getMeasurementId() => _measurementData.getMeasurementId();

  MeasurementState getState() => _measurementData.getMeasurementState();

  MeasurementData getMeasurementData() => _measurementData;
}
