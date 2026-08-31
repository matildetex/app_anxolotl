import 'package:anxolotl_app/src/data/services/wellbeing_exercises/wellbeing_exercise_info.dart';
import 'package:anxolotl_app/src/data/services/wellbeing_exercises/exercises_service.dart';
import 'package:anxolotl_app/src/ui/datatypes/exercise_datatype.dart';
import 'package:flutter/material.dart';

enum MeditationExerciseState { PLAYER, FINISH }

enum MeditationExercisePlayerState { WAITING, PLAYING, PAUSED }

class MeditationExerciseViewModel extends ChangeNotifier {
  MeditationExerciseViewModel(this.wellbeingExercisesService);

  final WellbeingExercisesService wellbeingExercisesService;
  MeditationExerciseState _meditationExerciseState =
      MeditationExerciseState.PLAYER;

  MeditationExercisePlayerState _playerState =
      MeditationExercisePlayerState.WAITING;
  Duration _currentPosition = Duration.zero;
  Duration _lastSessionDuration = Duration.zero;

  //DO not notify immediately
  void resetMeditationExerciseState() {
    _meditationExerciseState = MeditationExerciseState.PLAYER;
    _lastSessionDuration = Duration.zero;
    notifyListeners();
  }

  void resetPlayer() {
    _lastSessionDuration = _currentPosition;
    changePlayingState(MeditationExercisePlayerState.WAITING);
    changeMusicCurrentPosition(Duration.zero);
  }

  Duration getLastSessionDuration() => _lastSessionDuration;

  bool isExerciseStateFinish() =>
      _meditationExerciseState == MeditationExerciseState.FINISH;

  bool isPlayerPlaying() =>
      _playerState == MeditationExercisePlayerState.PLAYING;

  void changePlayingState(MeditationExercisePlayerState newState) {
    _playerState = newState;
    notifyListeners();
  }

  void getPlayingState(MeditationExercisePlayerState newState) => _playerState;

  void advanceExerciseState() {
    _meditationExerciseState = MeditationExerciseState.FINISH;
    notifyListeners();
  }

  void changeMusicCurrentPosition(Duration newDuration) {
    _currentPosition = newDuration;
    notifyListeners();
  }

  Duration getMusicCurrentPosition() => _currentPosition;

  Iterable<MeditationExerciseDatatype> getMeditationExercises(
      BuildContext context) {
    return wellbeingExercisesService.meditationExercises.map(
        (MeditationExerciseInfo meditationExerciseInfo) =>
            MeditationExerciseDatatype(
                exerciseName: meditationExerciseInfo.getExerciseName(context),
                illustrationPath: meditationExerciseInfo.illustrationPath,
                minDuration: meditationExerciseInfo.totalDuration,
                meditationPath: meditationExerciseInfo.meditationPath,
                authors: meditationExerciseInfo.authors,
                totalDuration: meditationExerciseInfo.totalDuration,
                additionalInfo: meditationExerciseInfo.additionalInfo == null
                    ? ""
                    : meditationExerciseInfo.additionalInfo!(context)));
  }
}
