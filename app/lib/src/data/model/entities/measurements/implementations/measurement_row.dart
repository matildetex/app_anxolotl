/// *
/// Represents all the results captured in a single time point from a sensor
/// I.e. Steps, activity type and calories in the Activity Sensor at 15:00
class MeasurementRow {
  late final Map<String, dynamic> _resultsMap;
  late final DateTime timestamp;

  MeasurementRow({DateTime? newTimestamp}) {
    DateTime currentDateTime = DateTime.now();
    if (newTimestamp != null) {
      currentDateTime = newTimestamp;
    }

    _resultsMap = {};
    currentDateTime.subtract(
        Duration(milliseconds: currentDateTime.millisecondsSinceEpoch));
    timestamp = currentDateTime;
  }

  MeasurementRow.fromExisting(this.timestamp, Map<String, dynamic> results)
      : _resultsMap = results;

  void addResult(String divisionName, dynamic sensorValue) =>
      _resultsMap[divisionName] = sensorValue;

  void addAllResults(Map<String, dynamic> values) {
    values.forEach((key, value) => addResult(key, value));
  }

  Map<String, dynamic> getResults() => _resultsMap;
}
