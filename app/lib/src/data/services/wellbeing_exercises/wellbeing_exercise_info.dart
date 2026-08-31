import 'package:flutter/cupertino.dart';

class BreathingExerciseInfo {
  final String Function(BuildContext a) getExerciseName;
  final String illustrationPath;
  String Function(BuildContext a)? additionalInfo = (BuildContext a) => "";
  final Duration minDuration;
  final Duration? maxDuration;
  final Duration inspirationDuration;
  final Duration holdingDuration;
  final Duration expirationDuration;

  BreathingExerciseInfo(
      {required this.getExerciseName,
      required this.illustrationPath,
      required this.minDuration,
      required this.inspirationDuration,
      required this.holdingDuration,
      required this.expirationDuration,
      this.maxDuration,
      this.additionalInfo});
}

class MeditationExerciseInfo {
  final String Function(BuildContext a) getExerciseName;
  final String illustrationPath;
  String Function(BuildContext a)? additionalInfo = (BuildContext a) => "";
  final String meditationPath;
  final String authors;
  final Duration totalDuration;

  MeditationExerciseInfo(
      {required this.getExerciseName,
      required this.illustrationPath,
      required this.meditationPath,
      required this.authors,
      required this.totalDuration,
      this.additionalInfo});
}
