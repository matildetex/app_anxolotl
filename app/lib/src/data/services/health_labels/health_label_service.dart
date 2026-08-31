import 'package:anxolotl_app/src/data/data_acces/repositories/health_results_repository.dart';
import 'package:anxolotl_app/src/data/model/user/health_result_label.dart';

class HealthResultLabelService {
  final HealthResultsRepository healthResultsRepository;

  HealthResultLabelService(this.healthResultsRepository);

  Future<void> setupListeners(String userId) async {
    await healthResultsRepository.setupListeners(
        userId,
        (String userId, int totalDays) =>
            getAnxietyLastMonthResults(userId, totalDays: totalDays),
        getAnxietyTodayAverage);
  }

  Future<void> disconnectListeners() async =>
      await healthResultsRepository.clearListeners();

  HealthResultLabel getAnxietyLatestResult(String userId) =>
      healthResultsRepository.readLocalHealthResultLabelLatest(
          userId, HealthResultsRepoEnum.ANXIETY_LATEST);

  Iterable<HealthResultLabel> getAnxietyLastMonthResults(String userId,
      {int totalDays = 28}) {
    DateTime currDatetime = DateTime.now();
    DateTime today =
        DateTime(currDatetime.year, currDatetime.month, currDatetime.day);
    List<HealthResultLabel> resultsList = [];

    for (int day = 0; day <= totalDays; day++) {
      DateTime startingTime = today.subtract(Duration(days: day));
      DateTime endingTime = today.subtract(Duration(days: day - 1));
      List<HealthResultLabel> dailyHealthResultLabelList =
          healthResultsRepository
              .readLocalHealthResultLabelDaily(
                  userId,
                  HealthResultsRepoEnum.ANXIETY_HOURLY,
                  startingTime,
                  endingTime)
              .toList();

      if (dailyHealthResultLabelList.isEmpty) {
        resultsList.add(
            HealthResultLabel(userId, 0, endingTime.millisecondsSinceEpoch));
        continue;
      }

      double averageLabel = dailyHealthResultLabelList
              .map((e) => e.labelValue)
              .reduce((a, b) => a + b) /
          dailyHealthResultLabelList.length;

      resultsList.add(HealthResultLabel(
          userId, averageLabel, endingTime.millisecondsSinceEpoch));
    }

    return resultsList;
  }

  Iterable<HealthResultLabel> getAnxietyTodayHourlyLabelList(String userId) {
    DateTime currDatetime = DateTime.now();
    DateTime today =
        DateTime(currDatetime.year, currDatetime.month, currDatetime.day);
    List<HealthResultLabel> resultsList = [];

    DateTime startingTime = today;
    DateTime endingTime = today.add(const Duration(days: 1));
    List<HealthResultLabel> dailyHealthResultLabelList = healthResultsRepository
        .readLocalHealthResultLabelDaily(userId,
            HealthResultsRepoEnum.ANXIETY_HOURLY, startingTime, endingTime)
        .toList();

    if (dailyHealthResultLabelList.isEmpty) {
      resultsList
          .add(HealthResultLabel(userId, 0, endingTime.millisecondsSinceEpoch));
    } else {
      dailyHealthResultLabelList
          .map((healthResultDb) => HealthResultLabel(healthResultDb.userId,
              healthResultDb.labelValue, healthResultDb.timestamp))
          .forEach((healthResultLabel) {
        resultsList.add(HealthResultLabel(healthResultLabel.userId,
            healthResultLabel.labelValue, healthResultLabel.timestamp));
      });
    }
    return resultsList;
  }

  HealthResultLabel getAnxietyTodayAverage(String userId) {
    DateTime currDatetime = DateTime.now();
    DateTime today =
        DateTime(currDatetime.year, currDatetime.month, currDatetime.day);
    late HealthResultLabel resultsEntry;

    DateTime startingTime = today;
    DateTime endingTime = today.add(const Duration(days: 1));
    List<HealthResultLabel> dailyHealthResultLabelList = healthResultsRepository
        .readLocalHealthResultLabelDaily(userId,
            HealthResultsRepoEnum.ANXIETY_HOURLY, startingTime, endingTime)
        .toList();

    if (dailyHealthResultLabelList.isEmpty) {
      resultsEntry =
          HealthResultLabel(userId, -1, endingTime.millisecondsSinceEpoch);
    } else {
      double averageLabel = dailyHealthResultLabelList
              .map((e) => e.labelValue)
              .reduce((a, b) => a + b) /
          dailyHealthResultLabelList.length;
      resultsEntry = HealthResultLabel(
          userId, averageLabel, endingTime.millisecondsSinceEpoch);
    }
    return resultsEntry;
  }

  HealthResultLabel getPanicTodayOccurrences(String userId) {
    DateTime currDatetime = DateTime.now();
    DateTime today =
        DateTime(currDatetime.year, currDatetime.month, currDatetime.day);
    late HealthResultLabel resultsEntry;

    DateTime startingTime = today;
    DateTime endingTime = today.add(const Duration(days: 1));
    List<HealthResultLabel> dailyHealthResultLabelList = healthResultsRepository
        .readLocalHealthResultLabelDaily(
            userId, HealthResultsRepoEnum.PANIC, startingTime, endingTime)
        .toList();

    if (dailyHealthResultLabelList.isEmpty) {
      resultsEntry =
          HealthResultLabel(userId, 0, endingTime.millisecondsSinceEpoch);
    } else {
      double totalOccurrences = dailyHealthResultLabelList
          .map((HealthResultLabel entry) => entry.labelValue)
          .where((double labelValue) => labelValue > 0)
          .length
          .toDouble();
      resultsEntry = HealthResultLabel(
          userId, totalOccurrences, endingTime.millisecondsSinceEpoch);
    }
    return resultsEntry;
  }

  Iterable<HealthResultLabel> getPanicLastWeekResults(String userId,
      {int totalDays = 7}) {
    DateTime currDatetime = DateTime.now();
    DateTime today =
        DateTime(currDatetime.year, currDatetime.month, currDatetime.day);
    List<HealthResultLabel> resultsList = [];

    for (int day = 0; day <= totalDays; day++) {
      DateTime startingTime = today.subtract(Duration(days: day));
      DateTime endingTime = today.subtract(Duration(days: day - 1));
      List<HealthResultLabel> dailyHealthResultLabelList =
          healthResultsRepository
              .readLocalHealthResultLabelDaily(
                  userId, HealthResultsRepoEnum.PANIC, startingTime, endingTime)
              .toList();

      if (dailyHealthResultLabelList.isEmpty) {
        resultsList.add(
            HealthResultLabel(userId, 0, endingTime.millisecondsSinceEpoch));
        continue;
      }

      double totalOccurrences = dailyHealthResultLabelList
          .map((HealthResultLabel entry) => entry.labelValue)
          .where((double labelValue) => labelValue > 0)
          .length
          .toDouble();

      resultsList.add(HealthResultLabel(
          userId, totalOccurrences, endingTime.millisecondsSinceEpoch));
    }

    return resultsList;
  }
}
