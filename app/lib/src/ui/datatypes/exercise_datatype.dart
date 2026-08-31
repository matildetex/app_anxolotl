abstract class ExerciseDatatype {
  abstract String exerciseName;
  abstract final String illustrationPath;
  abstract String additionalInfo;
  abstract Duration minDuration;
  abstract Duration? maxDuration;

  int getDurationInMinutes() {
    if (maxDuration == null) {
      return minDuration.inMinutes;
    } else {
      return maxDuration!.inMinutes;
    }
  }

  String getFullDurationString() {
    if (maxDuration == null) {
      return "${minDuration.inMinutes}";
    } else {
      return "${minDuration.inMinutes} - ${maxDuration!.inMinutes}";
    }
  }
}

class BreathingExerciseDatatype extends ExerciseDatatype {
  @override
  String exerciseName;
  @override
  final String illustrationPath;
  @override
  String additionalInfo;
  @override
  Duration? maxDuration;
  @override
  Duration minDuration;

  final Duration inspirationDuration;
  final Duration holdingDuration;
  final Duration expirationDuration;

  BreathingExerciseDatatype(
      {required this.exerciseName,
      required this.illustrationPath,
      required this.minDuration,
      required this.inspirationDuration,
      required this.holdingDuration,
      required this.expirationDuration,
      this.maxDuration,
      this.additionalInfo = ""});
}

class MeditationExerciseDatatype extends ExerciseDatatype {
  @override
  String exerciseName;
  @override
  final String illustrationPath;
  @override
  String additionalInfo;
  @override
  Duration? maxDuration;
  @override
  Duration minDuration;
  final String meditationPath;
  final String authors;
  final Duration totalDuration;

  MeditationExerciseDatatype(
      {required this.exerciseName,
      required this.illustrationPath,
      required this.minDuration,
      required this.meditationPath,
      required this.authors,
      required this.totalDuration,
      this.maxDuration,
      this.additionalInfo = ""});
}
