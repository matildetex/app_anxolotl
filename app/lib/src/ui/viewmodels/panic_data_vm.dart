import 'dart:core';

import 'package:anxolotl_app/src/data/model/user/health_result_label.dart';
import 'package:anxolotl_app/src/data/model/user/user_profile.dart';
import 'package:anxolotl_app/src/data/services/authentication/authentication_service.dart';
import 'package:anxolotl_app/src/data/services/health_labels/health_label_service.dart';
import 'package:anxolotl_app/src/ui/datatypes/overview_datatypes.dart';
import 'package:flutter/material.dart';

class PanicDataViewModel extends ChangeNotifier {
  final HealthResultLabelService _healthResultLabelsService;
  final AuthenticationService _authenticationService;

  PanicDataViewModel(
      this._healthResultLabelsService, this._authenticationService);

  OverviewDataType getTodayPanicOccurrences() {
    AuthProfile authProfile = _authenticationService.getUserProfile()!;

    HealthResultLabel healthResultLabel =
        _healthResultLabelsService.getPanicTodayOccurrences(authProfile.id);

    if (healthResultLabel.labelValue < 0) {
      healthResultLabel = HealthResultLabel(
          healthResultLabel.userId, 0, healthResultLabel.timestamp);
    }

    return OverviewDataType(
        DateTime.fromMillisecondsSinceEpoch(healthResultLabel.timestamp),
        healthResultLabel.labelValue);
  }

  Iterable<OverviewDataType> getLastWeekPanicOccurrences() {
    AuthProfile authProfile = _authenticationService.getUserProfile()!;

    Iterable<HealthResultLabel> healthResultLabelIterable =
        _healthResultLabelsService.getPanicLastWeekResults(authProfile.id,
            totalDays: 7);

    //DEBUG PURPOSES
    /*
    int i = 515;
    healthResultLabelIterable = healthResultLabelIterable.map((e)  {
      return HealthResultLabel(e.userId, Random(i++).nextInt(3).toDouble(), e.timestamp);
    });
    */

    return healthResultLabelIterable.map((HealthResultLabel healthResult) =>
        OverviewDataType(
            DateTime.fromMillisecondsSinceEpoch(healthResult.timestamp),
            healthResult.labelValue));
  }
}
