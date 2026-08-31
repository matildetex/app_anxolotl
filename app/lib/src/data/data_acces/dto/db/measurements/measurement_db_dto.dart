import 'package:anxolotl_app/src/data/model/entities/measurements/implementations/measurement_data.dart';
import 'package:anxolotl_app/src/data/model/entities/measurements/measurement_input_type.dart';
import 'package:objectbox/objectbox.dart';

@Entity()
class MeasurementDbDto {
  @Id()
  int id = 0;
  final String userId;
  final String measurementId;
  final int measurementType;

  MeasurementDbDto(
      this.userId, this.measurementId, this.measurementType); //in hertz

  MeasurementDbDto.fromMeasurement(this.userId, MeasurementData measurementData)
      : measurementId = measurementData.getMeasurementId(),
        //this.resultsMap = measurementData.getResults().map((key, value) => MapEntry(key,value.map((sensorValue) => SensorValueDBDto(sensorValue.index, sensorValue.value)).toList())),
        measurementType = measurementData.getMeasurementType().index;

  MeasurementData mapToMeasurementData() {
    MeasurementData newMeasurementData = MeasurementData.withId(
        measurementId, MeasurementType.values[measurementType]);
    //newMeasurementData.getResults().addAll(this.resultsMap.map((key, value) => MapEntry(key, value.map((sensorValueDbDto) => SensorValue(sensorValueDbDto.id,sensorValueDbDto.value)).toList())));

    return newMeasurementData;
  }
}
