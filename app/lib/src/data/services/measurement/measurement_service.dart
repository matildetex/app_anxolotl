import 'package:anxolotl_app/src/data/data_acces/repositories/imeasurement_repository.dart';
import 'package:anxolotl_app/src/data/model/entities/common/sensor/sensor.dart';
import 'package:anxolotl_app/src/data/model/entities/common/sensor_info.dart';
import 'package:anxolotl_app/src/data/model/entities/measurements/implementations/measurement.dart';
import 'package:anxolotl_app/src/data/model/entities/measurements/implementations/measurement_data.dart';
import 'package:anxolotl_app/src/data/model/entities/measurements/implementations/measurement_state.dart';
import 'package:anxolotl_app/src/data/model/user/user_profile.dart';
import 'package:anxolotl_app/src/data/services/device/contracts/acquisition_objects.dart';
import 'package:anxolotl_app/src/data/services/foreground_operations/operations/tokens.dart';

class MeasurementService {
  final IMeasurementRepository measurementRepository;

  MeasurementService(this.measurementRepository);

  final Map<String, Measurement> _onGoingMeasurements = {};

  String createNew(
      {required Sensor currSensor,
      required Measurement configMeasurement,
      SensorMeasurementInfo? sensorMeasurementInfo}) {
    Measurement newMeasurement =
        Measurement.CopyFromExisting(currSensor, configMeasurement);

    _onGoingMeasurements[newMeasurement.getMeasurementId()] = newMeasurement;
    return newMeasurement.getMeasurementId();
  }

  Future<String> startMeasuring(
      String measurementId,
      Stream<AcquisitionReturn> values,
      CancellationToken cancellationToken) async {
    Measurement measurement = getMeasurement(measurementId);

    await measurement.startMeasuring(values, cancellationToken);
    return measurement.getMeasurementId();
  }

  bool stopMeasuring(String measurementId) {
    try {
      getMeasurement(measurementId).finish();
      return true;
    } catch (E) {
      return false;
    }
  }

  MeasurementState getMeasurementState(String measurementId) =>
      getMeasurement(measurementId).getState();

  void saveMeasurement(String userId, String measurementId) {
    bool saved = false;
    try {
      measurementRepository.saveLocal(
          userId, _onGoingMeasurements[measurementId]!.getMeasurementData());
      print("\n\nSaved Local\n\n");
      saved = true;
      _removeMeasurementFromMemory(measurementId);
    } catch (E) {
      print("Exception: $E");
      if (saved) _removeMeasurementFromMemory(measurementId);
    }
  }

  //TODO add synchronization based on time, or conditions
  Future<void> syncMeasurements(
      AuthProfile authProfile, Duration workSamplingTime) async {
    try {
      clearInvalidMeasurements(workSamplingTime);

      Iterable<MeasurementData> data =
          measurementRepository.readAllLocal(authProfile.id);

      List<String> measurementSensorModality = [];
      List<MeasurementData> finalData = [];
      for (var measurementData in data) {
        if (!measurementSensorModality
            .contains(measurementData.getSensorName())) {
          measurementSensorModality.add(measurementData.getSensorName());
          finalData.add(measurementData);
        } else {
          finalData
              .firstWhere((MeasurementData finalDataEntry) =>
                  finalDataEntry.getSensorName() ==
                  measurementData.getSensorName())
              .addAllResults(measurementData.getResults());
        }
      }

      await measurementRepository
          .multiSaveUpload(authProfile, finalData)
          .then((_) {
        for (var measurement in data) {
          measurementRepository.deleteLocal(measurement.getMeasurementId());
          _removeMeasurementFromMemory(measurement.getMeasurementId());
        }
      });
      //await Future.wait(futuresToSync);
    } catch (E) {
      print(E.toString());
      print('Synchronization could not be performed');
    }
  }

  Measurement getMeasurement(String measurementId) {
    return _onGoingMeasurements.values.firstWhere(
        (measurement) => measurement.getMeasurementId() == measurementId);
  }

  bool containsMeasurement(String measurementId) {
    return _onGoingMeasurements.containsKey(measurementId);
  }

  void restartMeasurement() {
    _onGoingMeasurements.clear();
  }

  void _removeMeasurementFromMemory(String measurementId) =>
      _onGoingMeasurements.remove(measurementId);

  void clearInvalidMeasurements(Duration workSamplingTime) {
    Duration maxWaitingTimeAllowed = const Duration(minutes: 4);
    if (workSamplingTime.inSeconds * 2 > maxWaitingTimeAllowed.inSeconds) {
      maxWaitingTimeAllowed = Duration(seconds: workSamplingTime.inSeconds * 2);
    }

    List<String> measurementsToRemove = [];
    _onGoingMeasurements.forEach((key, value) {
      if (DateTime.now().difference(value.startingTime).inSeconds >
          maxWaitingTimeAllowed.inSeconds) {
        if (value.getResults().isEmpty) {
          measurementsToRemove.add(key);
        } else if (value
                .getResults()
                .first
                .timestamp
                .difference(value.startingTime)
                .inSeconds >
            maxWaitingTimeAllowed.inSeconds) {
          measurementsToRemove.add(key);
        }
      }
    });

    for (var key in measurementsToRemove) {
      if (_onGoingMeasurements[key] != null &&
          _onGoingMeasurements[key]!.getState() != MeasurementState.FINISHED) {
        _onGoingMeasurements[key]!
            .getMeasurementData()
            .setMeasurementState(MeasurementState.FINISHED);
        _onGoingMeasurements.remove(key);
      }
    }
  }
}
