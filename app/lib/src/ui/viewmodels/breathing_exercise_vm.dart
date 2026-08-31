import 'package:anxolotl_app/src/data/services/wellbeing_exercises/wellbeing_exercise_info.dart';
import 'package:anxolotl_app/src/data/services/wellbeing_exercises/exercises_service.dart';
import 'package:anxolotl_app/src/ui/datatypes/exercise_datatype.dart';
import 'package:flutter/material.dart';

enum BreathingPageState { CONFIG, EXERCISE, FINISH }

enum BreathingExerciseState { WAITING, RUNNING, FINISHED }

class BreathingExerciseViewModel extends ChangeNotifier {
  BreathingExerciseViewModel(this.wellbeingExercisesService);

  final WellbeingExercisesService wellbeingExercisesService;
  BreathingExerciseState _breathingExerciseState =
      BreathingExerciseState.WAITING;
  BreathingPageState _pageExerciseState = BreathingPageState.CONFIG;
  final int maxMinutes = 10;
  final int minMinutes = 1;

  int _minutesCounter = 2;
  int _breathCounter = 0;

  int getMinutesCounter() => _minutesCounter;

  void addToMinutesCounter(int value) {
    if (_minutesCounter + value > maxMinutes ||
        _minutesCounter + value < minMinutes) {
      return;
    }
    _minutesCounter += value;
    notifyListeners();
  }

  void nextPageState() {
    _pageExerciseState =
        BreathingPageState.values[_pageExerciseState.index + 1];
    notifyListeners();
  }

  void resetPageState() {
    _pageExerciseState = BreathingPageState.CONFIG;
  }

  BreathingPageState getPageState() => _pageExerciseState;

  void nextBreathingExerciseState() {
    _breathingExerciseState =
        BreathingExerciseState.values[_breathingExerciseState.index + 1];
    notifyListeners();
  }

  void resetBreathingExerciseState() =>
      _breathingExerciseState = BreathingExerciseState.WAITING;

  void resetBreathingCounter() => _breathCounter = 0;

  void increaseBreathCounter() => _breathCounter++;

  int getBreathCounter() => _breathCounter;

  bool breathingExerciseStarted() =>
      _breathingExerciseState == BreathingExerciseState.WAITING;

  bool breathingExerciseFinished() =>
      _breathingExerciseState == BreathingExerciseState.FINISHED;

  BreathingExerciseState getBreathingExerciseState() => _breathingExerciseState;

  Iterable<BreathingExerciseDatatype> getBreathingExercises(
      BuildContext context) {
    return wellbeingExercisesService.breathingExercises.map(
        (BreathingExerciseInfo breathingExerciseInfo) =>
            BreathingExerciseDatatype(
                exerciseName: breathingExerciseInfo.getExerciseName(context),
                illustrationPath: breathingExerciseInfo.illustrationPath,
                inspirationDuration: breathingExerciseInfo.inspirationDuration,
                minDuration: breathingExerciseInfo.minDuration,
                maxDuration: breathingExerciseInfo.maxDuration,
                holdingDuration: breathingExerciseInfo.holdingDuration,
                expirationDuration: breathingExerciseInfo.expirationDuration,
                additionalInfo: breathingExerciseInfo.additionalInfo == null
                    ? ""
                    : breathingExerciseInfo.additionalInfo!(context)));
  }
}
