class OverviewDataType {
  final double value;
  final DateTime date;

  OverviewDataType(this.date, this.value);
}

class MeasuredLevelsDataType {
  final double value;
  final Duration duration;

  MeasuredLevelsDataType(this.duration, this.value);
}
