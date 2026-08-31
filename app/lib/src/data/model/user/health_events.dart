import 'package:anxolotl_app/src/data/data_acces/dto/db/health_results/health_event_db_dto.dart';

enum HealthEventsEnum {
  PANIC_DETECTED,
  HIGH_ANXIETY_TODAY,
  HIGH_ANXIETY_FOUR_DAYS
}

class HealthEvent {
  late final String userId;
  late final HealthEventsEnum healthEventReason;
  late final int timestamp;

  HealthEvent(this.userId, this.healthEventReason, this.timestamp);

  HealthEvent.fromDto(HealthEventDbDto healthEventDbDto)
      : userId = healthEventDbDto.userId,
        healthEventReason =
            HealthEventsEnum.values[healthEventDbDto.healthEventsIndex],
        timestamp = healthEventDbDto.timestamp;
}
