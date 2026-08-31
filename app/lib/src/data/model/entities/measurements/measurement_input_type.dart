enum MeasurementType { DISCRETE_AVG, DISCRETE, CONTINUOUS, USER_INPUT }

///Simple class used to map all the possible Measurements
class MeasurementInfo {
  late final Duration duration;
  final MeasurementType measurementInputType;

  MeasurementInfo(this.measurementInputType, {Duration? duration}) {
    if (duration == null) this.duration = const Duration(seconds: 0);
  }
}

class MeasurementInfoContinuous extends MeasurementInfo {
  @override
  final Duration duration;

  MeasurementInfoContinuous(this.duration) : super(MeasurementType.CONTINUOUS);
}

class MeasurementInfoDiscreteAvg extends MeasurementInfo {
  @override
  final Duration duration;

  MeasurementInfoDiscreteAvg(this.duration)
      : super(MeasurementType.DISCRETE_AVG);
}

///WARNING: When a Discrete Measure is taken, the frequency must be 10HZ or lower
class MeasurementInfoDiscrete extends MeasurementInfo {
  /// if automatic is false, it means it will use manual inputs
  MeasurementInfoDiscrete({required bool automatic})
      : super(
            automatic ? MeasurementType.DISCRETE : MeasurementType.USER_INPUT);
}
