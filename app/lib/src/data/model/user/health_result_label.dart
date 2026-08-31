import 'package:anxolotl_app/src/data/data_acces/dto/db/health_results/health_result_label_db_dto.dart';

class HealthResultLabel {
  //IN cm
  late final String userId;
  late final double labelValue;
  late final int timestamp;

  HealthResultLabel(this.userId, this.labelValue, this.timestamp);

  HealthResultLabel.fromDbValue(HealthResultLabelDbDto healthResultLabelDbDto) {
    userId = healthResultLabelDbDto.userId;
    labelValue = healthResultLabelDbDto.labelValue;
    timestamp = healthResultLabelDbDto.timestamp;
  }
}
