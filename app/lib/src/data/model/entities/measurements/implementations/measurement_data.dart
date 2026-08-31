import 'package:anxolotl_app/src/data/model/entities/measurements/implementations/measurement_row.dart';
import 'package:anxolotl_app/src/data/model/entities/measurements/implementations/measurement_state.dart';
import 'package:anxolotl_app/src/data/model/entities/measurements/measurement_input_type.dart';

class MeasurementData {
  late MeasurementState _measurementState = MeasurementState.CREATED;
  late final String _measurementId;

  final MeasurementType _measurementType;
  final List<MeasurementRow> _resultsList = [];

  MeasurementData(String sensorName, this._measurementType) {
    DateTime currDatetime = DateTime.now();
    currDatetime = currDatetime
        .subtract(Duration(milliseconds: currDatetime.millisecondsSinceEpoch));
    _measurementId = "${sensorName}_${currDatetime.toIso8601String()}";
  }

  String getSensorName() => _measurementId.split("_")[0];

  MeasurementData.withId(this._measurementId, this._measurementType);

  MeasurementState getMeasurementState() => _measurementState;

  void setMeasurementState(MeasurementState measurementState) =>
      _measurementState = measurementState;

  String getMeasurementId() => _measurementId;

  List<MeasurementRow> getResults() => _resultsList;

  /// Adding a full completed row
  DateTime addNewResultRow(DateTime timeStamp, Map<String, dynamic> values) {
    MeasurementRow newRow = MeasurementRow(newTimestamp: timeStamp);
    newRow.addAllResults(values);
    _resultsList.add(newRow);
    return newRow.timestamp;
  }

  /// Adding a pair name, value to a row, that might exist or not
  DateTime addSingleRow(DateTime timeStamp, String name, String value) {
    if (!_resultsList.any((element) => element.timestamp == timeStamp)) {
      MeasurementRow newRow = MeasurementRow(newTimestamp: timeStamp);
      _resultsList.add(newRow);
    }
    _resultsList
        .firstWhere((element) => element.timestamp == timeStamp)
        .addResult(name, value);
    return timeStamp;
  }

  void addAllResults(List<MeasurementRow> resultRows) {
    _resultsList.addAll(resultRows);
  }

  MeasurementType getMeasurementType() => _measurementType;
}
