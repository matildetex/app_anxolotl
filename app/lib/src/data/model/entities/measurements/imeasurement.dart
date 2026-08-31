///Defines all the attributes an exam should have, to be valid
///[U] Must be a comparable value. It will be used as an identifier
///[T] Must be an implementation of exam
/*abstract class IMeasurement<T, U extends IExam> {
  final Sensor sensorInfo;
  ///The frequency to be used in this measurement
  final SensorFrequency frequency;
  /// The independent unit of the measurement, usually it will be time in "ms"
  final String independentUnit;
  final MeasurementInfo measurementInfo;
  ///Current exam being taken, in case of being an exam being taken, might be null
  abstract U? currExam;

  IMeasurement(this.sensorInfo, this.frequency, this.independentUnit, this.measurementInfo);

  bool addValueFromSource(
      DeviceChannelOperation deviceChannelOperation, double sampledValue);

  bool startExam();

  U finishExam();

  T getResult(String examDivisionName);

  String getMeasurementUnit(String channelSignalName,String examDivisionName) {
    return channelOperations
        .firstWhere((channelOper) => channelOper.channelSignalName ==
        channelSignalName).measurementUnits[examDivisionName]!;
  }
}*/
