import 'package:anxolotl_app/src/data/data_acces/dto/api/measurements/measurement_json_dto.dart';
import 'package:anxolotl_app/src/data/data_acces/dto/api/measurements/measurement_row_json_dto.dart';
import 'package:anxolotl_app/src/data/model/entities/measurements/implementations/measurement_data.dart';
import 'package:anxolotl_app/src/data/model/entities/measurements/implementations/measurement_row.dart';
import 'package:anxolotl_app/src/data/model/user/user_profile.dart';

class MeasurementDataMapper {
  static MeasurementJsonDto measurementToMeasurementDto(
      AuthProfile authProfile, MeasurementData measurement) {
    return MeasurementJsonDto(
        authProfile.id,
        measurement.getMeasurementId(),
        measurement.getMeasurementType().index,
        measurement.getResults().map((MeasurementRow measurementRow) {
          Map<String, dynamic> results = measurementRow.getResults();
          //results['timestamp'] = measurementRow.timestamp.millisecondsSinceEpoch;
          return MeasurementRowJsonDto(results);
        }).toList());
  }
}
