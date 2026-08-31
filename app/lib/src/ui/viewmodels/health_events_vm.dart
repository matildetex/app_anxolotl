import 'package:anxolotl_app/src/data/model/user/health_events.dart';
import 'package:anxolotl_app/src/data/services/authentication/authentication_service.dart';
import 'package:anxolotl_app/src/data/services/health_labels/health_event_service.dart';
import 'package:anxolotl_app/src/ui/datatypes/health_event_datatype.dart';
import 'package:flutter/material.dart';

class HealthEventsViewModel extends ChangeNotifier {
  final HealthEventService _healthEventService;
  final AuthenticationService _authenticationService;

  HealthEventsViewModel(this._healthEventService, this._authenticationService);

  Iterable<HealthEvent> readHealthNotifications() {
    return _healthEventService
        .readHealthNotifications(_authenticationService.getUserProfile()!.id);
    //DEBUG PURPOSES
    /*
    String userId = _authenticationService.getUserProfile()!.id;
    return [
      HealthEvent(userId, HealthEventsEnum.HIGH_ANXIETY_TODAY, DateTime.now().millisecondsSinceEpoch),
      HealthEvent(userId, HealthEventsEnum.PANIC_DETECTED, DateTime.now().subtract(Duration(days: 1)).millisecondsSinceEpoch),
      HealthEvent(userId, HealthEventsEnum.HIGH_ANXIETY_FOUR_DAYS, DateTime.now().subtract(Duration(days: 2)).millisecondsSinceEpoch),
    ];*/
  }

  HealthEventDatatype getHealthEventDatatype(
      HealthEventsEnum healthEventsEnum) {
    return _healthEventService.getHealthEventDetail(healthEventsEnum);
  }

  void deleteHealthNotification(HealthEvent healthEvent) {
    return _healthEventService.deleteHealthNotification(healthEvent);
  }
}
