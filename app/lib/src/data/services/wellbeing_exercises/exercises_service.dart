import 'package:anxolotl_app/globals/assets_path.dart';
import 'package:anxolotl_app/src/data/services/wellbeing_exercises/wellbeing_exercise_info.dart';
import 'package:anxolotl_app/src/lang/anxolotl_localizations.dart';
import 'package:flutter/material.dart';

class WellbeingExercisesService {
  final List<BreathingExerciseInfo> breathingExercises = [
    BreathingExerciseInfo(
        getExerciseName: (BuildContext a) =>
            LocalizationsUtil.l10n(a).stressBreathingGuidance,
        illustrationPath: "${AssetsPath.EXERCISES_ASSETS}stress_breathing.png",
        minDuration: const Duration(minutes: 1),
        maxDuration: const Duration(minutes: 10),
        inspirationDuration: const Duration(seconds: 4),
        holdingDuration: const Duration(seconds: 5),
        expirationDuration: const Duration(seconds: 6),
        additionalInfo: (BuildContext a) =>
            LocalizationsUtil.l10n(a).deepBreaths),
    BreathingExerciseInfo(
      getExerciseName: (BuildContext a) =>
          LocalizationsUtil.l10n(a).anxietyBreathingGuidance,
      illustrationPath: "${AssetsPath.EXERCISES_ASSETS}anxiety_breathing.png",
      minDuration: const Duration(minutes: 1),
      maxDuration: const Duration(minutes: 10),
      inspirationDuration: const Duration(seconds: 5),
      holdingDuration: const Duration(seconds: 2),
      expirationDuration: const Duration(seconds: 5),
    ),
    BreathingExerciseInfo(
      getExerciseName: (BuildContext a) =>
          LocalizationsUtil.l10n(a).panicBreathingGuidance,
      illustrationPath: "${AssetsPath.EXERCISES_ASSETS}panic_breathing.png",
      minDuration: const Duration(minutes: 1),
      maxDuration: const Duration(minutes: 10),
      inspirationDuration: const Duration(seconds: 3),
      holdingDuration: const Duration(seconds: 0),
      expirationDuration: const Duration(seconds: 3),
    ),
  ];

  final List<MeditationExerciseInfo> meditationExercises = [
    MeditationExerciseInfo(
        getExerciseName: (BuildContext a) =>
            LocalizationsUtil.l10n(a).briefMindfulnessExerciseName,
        illustrationPath: "${AssetsPath.EXERCISES_ASSETS}brief_meditation.png",
        meditationPath: '${AssetsPath.EXERCISES_ASSETS}FreeMindfulness_BriefMindfulness.mp3',
        authors: "Padraig O'Morain",
        totalDuration: const Duration(minutes: 4, seconds: 5)),
    MeditationExerciseInfo(
        getExerciseName: (BuildContext a) =>
            LocalizationsUtil.l10n(a).mountainMeditationExerciseName,
        illustrationPath:
            "${AssetsPath.EXERCISES_ASSETS}mountain_meditation.png",
        meditationPath: '${AssetsPath.EXERCISES_ASSETS}FreeMindfulness_MountainMeditation.mp3',
        authors: "Peter Morgan",
        totalDuration: const Duration(minutes: 8, seconds: 12)),
  ];
}
