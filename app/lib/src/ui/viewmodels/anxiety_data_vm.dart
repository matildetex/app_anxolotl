import 'dart:core';

import 'package:anxolotl_app/src/data/model/user/health_result_label.dart';
import 'package:anxolotl_app/src/data/model/user/user_profile.dart';
import 'package:anxolotl_app/src/data/services/authentication/authentication_service.dart';
import 'package:anxolotl_app/src/data/services/health_labels/health_label_service.dart';
import 'package:anxolotl_app/src/data/services/health_profile/utils.dart';
import 'package:anxolotl_app/src/ui/datatypes/overview_datatypes.dart';
import 'package:flutter/material.dart';

class AnxietyDataViewModel extends ChangeNotifier {
  final ValueInterval<double> _anxietyValuesInterval = ValueInterval(0, 2);
  final HealthResultLabelService _healthResultLabelsService;
  final AuthenticationService _authenticationService;

  AnxietyDataViewModel(
      this._healthResultLabelsService, this._authenticationService);

  OverviewDataType getCurrentAnxietyValue() {
    AuthProfile authProfile = _authenticationService.getUserProfile()!;

    HealthResultLabel healthResultLabel =
        _healthResultLabelsService.getAnxietyLatestResult(authProfile.id);

    if (healthResultLabel.labelValue < 0) {
      healthResultLabel = HealthResultLabel(
          healthResultLabel.userId, 0, healthResultLabel.timestamp);
    }

    return OverviewDataType(
        DateTime.fromMillisecondsSinceEpoch(healthResultLabel.timestamp),
        healthResultLabel.labelValue);
  }

  OverviewDataType getTodayAnxietyAverage() {
    AuthProfile authProfile = _authenticationService.getUserProfile()!;

    HealthResultLabel healthResultLabel =
        _healthResultLabelsService.getAnxietyTodayAverage(authProfile.id);

    //DEBUG PURPOSES
    /*
    return OverviewDataType(
        DateTime.fromMillisecondsSinceEpoch(healthResultLabel.timestamp),
        0.5);
   */

    return OverviewDataType(
        DateTime.fromMillisecondsSinceEpoch(healthResultLabel.timestamp),
        healthResultLabel.labelValue);
  }

  Iterable<OverviewDataType> getLastMonthAnxietyValue() {
    AuthProfile authProfile = _authenticationService.getUserProfile()!;

    Iterable<HealthResultLabel> healthResultLabelIterable =
        _healthResultLabelsService.getAnxietyLastMonthResults(authProfile.id,
            totalDays: 28);

    //DEBUG PURPOSES
    /*
    int i = 105;
    healthResultLabelIterable = healthResultLabelIterable.map((e)  {
      return HealthResultLabel(e.userId, Random(i++).nextDouble()*2, e.timestamp);
    });
    */

    return healthResultLabelIterable.map((HealthResultLabel healthResult) =>
        OverviewDataType(
            DateTime.fromMillisecondsSinceEpoch(healthResult.timestamp),
            healthResult.labelValue));
  }

  ValueInterval<double> getAnxietyLevelsInterval() => _anxietyValuesInterval;

  MeasuredLevelsDataType getTodayMaxAnxietyValues() {
    int hoursBetweenMeasurements = 1;
    AuthProfile authProfile = _authenticationService.getUserProfile()!;

    List<OverviewDataType> anxietyDailyValues = _healthResultLabelsService
        .getAnxietyTodayHourlyLabelList(authProfile.id)
        .map((HealthResultLabel healthResult) => OverviewDataType(
            DateTime.fromMillisecondsSinceEpoch(healthResult.timestamp),
            healthResult.labelValue))
        .toList();

    double maxValueToSearch = anxietyDailyValues
        .reduce((curr, next) => curr.value > next.value ? curr : next)
        .value;

    Iterable<int> maxValuesIndexArray = anxietyDailyValues
        .where((entry) => entry.value == maxValueToSearch)
        .map((OverviewDataType dataType) =>
            anxietyDailyValues.indexOf(dataType));

    List<int> biggestValues = [];
    List<int> currentValues = [];

    for (var index in maxValuesIndexArray) {
      if (currentValues.isEmpty || currentValues.last + 1 == index) {
        if (currentValues.isEmpty) {
          biggestValues.add(index);
        }
        currentValues.add(index);
      } else {
        if (currentValues.length > biggestValues.length) {
          biggestValues.clear();
          biggestValues.addAll(currentValues);
        }
        currentValues.clear();
        currentValues.add(index);
      }
    }

    if (maxValueToSearch < 1) {
      maxValueToSearch = -1;
    }

    //DEBUG PURPOSES
    /*
    return MeasuredLevelsDataType(
        Duration(hours: hoursBetweenMeasurements * 3),
        2);
   */

    return MeasuredLevelsDataType(
        Duration(hours: hoursBetweenMeasurements * biggestValues.length),
        maxValueToSearch);
  }

  Future<void> setupListeners() async {
    await disconnectListeners();
    await _healthResultLabelsService
        .setupListeners(_authenticationService.getUserProfile()!.id);
  }

  Future<void> disconnectListeners() async =>
      await _healthResultLabelsService.disconnectListeners();
}
