import 'package:anxolotl_app/src/data/data_acces/repositories/health_results_repository.dart';
import 'package:anxolotl_app/src/data/model/user/health_events.dart';
import 'package:anxolotl_app/src/lang/anxolotl_localizations.dart';
import 'package:anxolotl_app/src/ui/datatypes/health_event_datatype.dart';

class HealthEventService {
  final HealthResultsRepository _healthResultsRepository;
  late final AnxolotlLocalizations anxolotlLocalizations;
  late final Map<int, HealthEventDatatype> _healthEventMap;

  Future<HealthEventService> init() async {
    anxolotlLocalizations = await LocalizationsUtil.l10nContextless();
    _healthEventMap = {
      HealthEventsEnum.PANIC_DETECTED.index: HealthEventDatatype(
        title: anxolotlLocalizations.panicDetectedExp,
        explanation: anxolotlLocalizations.panicDetectedExplanation,
      ),
      HealthEventsEnum.HIGH_ANXIETY_TODAY.index: HealthEventDatatype(
        title: anxolotlLocalizations.highAnxietyTodayExp,
        explanation: anxolotlLocalizations.highAnxietyTodayExplanation,
      ),
      HealthEventsEnum.HIGH_ANXIETY_FOUR_DAYS.index: HealthEventDatatype(
        title: anxolotlLocalizations.highAnxietyLastDaysExp,
        explanation: anxolotlLocalizations.highAnxietyLastDaysExplanation,
      )
    };
    return this;
  }

  HealthEventService(this._healthResultsRepository);

  Iterable<HealthEvent> readHealthNotifications(String userId) =>
      _healthResultsRepository.readLocalHealthNotifications(userId);

  void deleteHealthNotification(HealthEvent healthEvent) =>
      _healthResultsRepository.deleteLocalHealthNotification(healthEvent);

  HealthEventDatatype getHealthEventDetail(HealthEventsEnum healthEventsEnum) =>
      _healthEventMap[healthEventsEnum.index]!;
}
