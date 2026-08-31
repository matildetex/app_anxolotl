import 'package:anxolotl_app/src/data/data_acces/api/amqp/amqp_api.dart';
import 'package:anxolotl_app/src/data/data_acces/api/amqp/amqp_utils.dart';
import 'package:anxolotl_app/src/data/data_acces/database/generated/objectbox.g.dart';
import 'package:anxolotl_app/src/data/data_acces/database/object_box_db.dart';
import 'package:anxolotl_app/src/data/data_acces/dto/db/health_results/health_event_db_dto.dart';
import 'package:anxolotl_app/src/data/data_acces/dto/db/health_results/health_result_label_db_dto.dart';
import 'package:anxolotl_app/src/data/model/user/health_events.dart';
import 'package:anxolotl_app/src/data/model/user/health_result_label.dart';
import 'package:dart_amqp/dart_amqp.dart';

enum HealthResultsRepoEnum { ANXIETY_HOURLY, ANXIETY_LATEST, PANIC }

class HealthResultsRepository {
  final Store _db = ObjectBoxDb().getDatabase();
  late final Box<HealthResultLabelDbDto> _anxietyLatestBox;
  late final Box<HealthResultLabelDbDto> _anxietyHourlyBox;
  late final Box<HealthResultLabelDbDto> _panicBox;
  late final Box<HealthEventDbDto> _healthEventsBox;
  final AmqpApi amqpApi;
  int maxHighAnxietyDays = 4;

  late final Map<HealthResultsRepoEnum, Box<HealthResultLabelDbDto>> _boxMap;

  HealthResultsRepository(this.amqpApi) {
    _anxietyLatestBox = _db.box<HealthResultLabelDbDto>();
    _anxietyHourlyBox = _db.box<HealthResultLabelDbDto>();
    _panicBox = _db.box<HealthResultLabelDbDto>();
    _healthEventsBox = _db.box<HealthEventDbDto>();
    _boxMap = {
      HealthResultsRepoEnum.ANXIETY_HOURLY: _anxietyHourlyBox,
      HealthResultsRepoEnum.ANXIETY_LATEST: _anxietyLatestBox,
      HealthResultsRepoEnum.PANIC: _panicBox,
    };
    //deleteAll();
  }

  Future<void> clearListeners() async => await amqpApi.clearListeners();

  Future<void> deleteAll() async {
    _anxietyLatestBox.removeAll();
    _panicBox.removeAll();
  }

  Future<void> setupListeners(
      String userId,
      Iterable<HealthResultLabel> Function(String userId, int days)
          getAnxietyDailyList,
      HealthResultLabel Function(String userId) getAnxietyTodayAvg) async {
    /****************************************************
     **********       ANXIETY LATEST        *************
     ****************************************************/

    amqpApi.createListener(AmqpPaths.ANXIETY_RESULTS_QUEUE, "anxiety.latest",
        (AmqpMessage message) async {
      if (message.properties == null ||
          message.properties!.contentType == null ||
          message.properties!.contentType != userId) {
        return;
      }
      HealthResultLabelDbDto healthResultLabelDbDto =
          HealthResultLabelDbDto.fromJson(message.payloadAsJson);
      _anxietyLatestBox.removeAll();
      _saveLocalHealthResultLabel(healthResultLabelDbDto, _anxietyLatestBox);
      print("#### resulttt ${healthResultLabelDbDto.labelValue}");
      message.ack();
    });

    /****************************************************
     **********       ANXIETY HOURLY        *************
     ****************************************************/

    amqpApi.createListener(AmqpPaths.ANXIETY_RESULTS_QUEUE, "anxiety.hourly",
        (AmqpMessage message) {
      if (message.properties == null ||
          message.properties!.contentType == null ||
          message.properties!.contentType != userId) {
        return;
      }
      HealthResultLabelDbDto healthResultLabelDbDto =
          HealthResultLabelDbDto.fromJson(message.payloadAsJson);
      _saveLocalHealthResultLabel(healthResultLabelDbDto, _anxietyHourlyBox);

      if (getAnxietyTodayAvg(healthResultLabelDbDto.userId).labelValue > 1.5) {
        HealthEventDbDto eventDbDto = HealthEventDbDto.fromEvent(
            healthResultLabelDbDto, HealthEventsEnum.HIGH_ANXIETY_TODAY);
        if (!_containsLocalHealthEventInstance(eventDbDto)) {
          _saveLocalHealthEvent(eventDbDto);
        }
      }

      if (getAnxietyDailyList(healthResultLabelDbDto.userId, maxHighAnxietyDays)
              .where((element) => element.labelValue >= 1)
              .length ==
          maxHighAnxietyDays) {
        HealthEventDbDto eventDbDto = HealthEventDbDto.fromEvent(
            healthResultLabelDbDto, HealthEventsEnum.HIGH_ANXIETY_FOUR_DAYS);
        if (!_containsLocalHealthEventInstance(eventDbDto)) {
          _saveLocalHealthEvent(eventDbDto);
        }
      }

      print("#### resulttt ${healthResultLabelDbDto.labelValue}");
      message.ack();
    });

    /****************************************************
     **********            PANIC            *************
     ****************************************************/
    amqpApi.createListener(AmqpPaths.PANIC_RESULTS_QUEUE, "panic",
        (AmqpMessage message) {
      if (message.properties == null ||
          message.properties!.contentType == null ||
          message.properties!.contentType != userId) {
        return;
      }
      HealthResultLabelDbDto healthResultLabelDbDto =
          HealthResultLabelDbDto.fromJson(message.payloadAsJson);
      _saveLocalHealthResultLabel(healthResultLabelDbDto, _panicBox);

      if (healthResultLabelDbDto.labelValue > 0) {
        HealthEventDbDto eventDbDto = HealthEventDbDto.fromEvent(
            healthResultLabelDbDto, HealthEventsEnum.PANIC_DETECTED);
        if (!_containsLocalHealthEventInstance(eventDbDto)) {
          _saveLocalHealthEvent(eventDbDto);
        }
      }

      print(
          "#### resulttt panic${healthResultLabelDbDto.labelValue}");
      message.ack();
    });
  }

  HealthResultLabel readLocalHealthResultLabelLatest(
      String userId, HealthResultsRepoEnum selectedBoxStr) {
    Box<HealthResultLabelDbDto> selectedBox = _boxMap[selectedBoxStr]!;

    DateTime currentDatetime = DateTime.now();
    DateTime minDatetime = DateTime(
        currentDatetime.year, currentDatetime.month, currentDatetime.day - 1);
    int minTimeStamp = minDatetime.millisecondsSinceEpoch;

    Query<HealthResultLabelDbDto> healthResultLabelQuery = selectedBox
        .query(HealthResultLabelDbDto_.userId.equals(userId) &
            HealthResultLabelDbDto_.timestamp.greaterOrEqual(minTimeStamp))
        .build();

    List<HealthResultLabelDbDto> dbResults = healthResultLabelQuery.find();

    if (dbResults.isEmpty) {
      return HealthResultLabel(
          userId, -1, currentDatetime.millisecondsSinceEpoch);
    }
    return HealthResultLabel.fromDbValue(
        dbResults.reduce((a, b) => a.timestamp < b.timestamp ? a : b));
  }

  Iterable<HealthResultLabel> readLocalHealthResultLabelDaily(
      String userId,
      HealthResultsRepoEnum selectedBoxStr,
      DateTime minTimestamp,
      DateTime maxTimestamp) {
    Box<HealthResultLabelDbDto> selectedBox = _boxMap[selectedBoxStr]!;

    int minTsMillis = minTimestamp.millisecondsSinceEpoch;
    int maxTsMillis = maxTimestamp.millisecondsSinceEpoch;

    Query<HealthResultLabelDbDto> healthResultLabelQuery = selectedBox
        .query(HealthResultLabelDbDto_.userId.equals(userId) &
            HealthResultLabelDbDto_.timestamp.greaterOrEqual(minTsMillis) &
            HealthResultLabelDbDto_.timestamp.lessThan(maxTsMillis))
        .build();

    List<HealthResultLabelDbDto> dbResults = healthResultLabelQuery.find();

    return dbResults
        .map((healthResultDb) => HealthResultLabel.fromDbValue(healthResultDb));
  }

  void _saveLocalHealthResultLabel(
      HealthResultLabelDbDto healthResultLabelDbDto,
      Box<HealthResultLabelDbDto> selectedBox) {
    selectedBox.put(healthResultLabelDbDto);
  }

  void _saveLocalHealthEvent(HealthEventDbDto healthEventDbDto) {
    _healthEventsBox.put(healthEventDbDto);
  }

  bool _containsLocalHealthEventInstance(HealthEventDbDto healthEventDbDto) {
    DateTime dayTimestamp =
        DateTime.fromMillisecondsSinceEpoch(healthEventDbDto.timestamp);
    dayTimestamp =
        DateTime(dayTimestamp.year, dayTimestamp.month, dayTimestamp.day);

    Query<HealthEventDbDto> healthResultLabelQuery = _healthEventsBox
        .query(HealthEventDbDto_.userId.equals(healthEventDbDto.userId) &
            HealthEventDbDto_.healthEventsIndex
                .equals(healthEventDbDto.healthEventsIndex) &
            HealthEventDbDto_.timestamp
                .greaterOrEqual(dayTimestamp.millisecondsSinceEpoch))
        .build();

    List<HealthEventDbDto> dbResults = healthResultLabelQuery.find();

    return dbResults.isEmpty;
  }

  Iterable<HealthEvent> readLocalHealthNotifications(String userId) {
    Query<HealthEventDbDto> healthResultLabelQuery =
        _healthEventsBox.query(HealthEventDbDto_.userId.equals(userId)).build();

    List<HealthEventDbDto> dbResults = healthResultLabelQuery.find();

    return dbResults.map((HealthEventDbDto healthEventDbDto) =>
        HealthEvent.fromDto(healthEventDbDto));
  }

  void deleteLocalHealthNotification(HealthEvent healthEvent) {
    Query<HealthEventDbDto> healthResultLabelQuery = _healthEventsBox
        .query(HealthEventDbDto_.userId.equals(healthEvent.userId) &
            HealthEventDbDto_.timestamp.equals(healthEvent.timestamp))
        .build();

    List<HealthEventDbDto> dbResults = healthResultLabelQuery.find();

    for (var healthEventDbDto in dbResults) {
      _healthEventsBox.remove(healthEventDbDto.id);
    }
  }
}
