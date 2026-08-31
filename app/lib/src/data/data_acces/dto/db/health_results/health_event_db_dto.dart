import 'package:anxolotl_app/src/data/data_acces/dto/db/health_results/health_result_label_db_dto.dart';
import 'package:anxolotl_app/src/data/model/user/health_events.dart';
import 'package:objectbox/objectbox.dart';

@Entity()
class HealthEventDbDto {
  @Id()
  int id = 0;
  late final String userId;
  late final int healthEventsIndex;
  late final int timestamp;

  HealthEventDbDto(this.userId, this.healthEventsIndex, this.timestamp);

  HealthEventDbDto.fromEvent(HealthResultLabelDbDto healthResultLabelDbDto,
      HealthEventsEnum healthEventsEnum)
      : userId = healthResultLabelDbDto.userId,
        healthEventsIndex = healthEventsEnum.index,
        timestamp = healthResultLabelDbDto.timestamp;
}
