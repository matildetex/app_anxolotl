import 'package:anxolotl_app/src/ui/datatypes/exercise_datatype.dart';
import 'package:anxolotl_app/src/ui/view/breathing_exercise/widgets/breathing_config_fragment.dart';
import 'package:anxolotl_app/src/ui/view/breathing_exercise/widgets/breathing_exercise_fragment.dart';
import 'package:anxolotl_app/src/ui/view/breathing_exercise/widgets/breathing_finish_fragment.dart';
import 'package:anxolotl_app/src/ui/view/common_widgets/custom_app_bar.dart';
import 'package:anxolotl_app/src/ui/viewmodels/breathing_exercise_vm.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BreathingExercisePage extends StatefulWidget {
  const BreathingExercisePage(
      {super.key, required this.breathingExerciseDatatype});
  final BreathingExerciseDatatype breathingExerciseDatatype;
  @override
  State<BreathingExercisePage> createState() => _BreathingExercisePageState();
}

class _BreathingExercisePageState extends State<BreathingExercisePage> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      BreathingExerciseViewModel breathingExerciseVM =
          Provider.of<BreathingExerciseViewModel>(context, listen: false);
      breathingExerciseVM.resetBreathingCounter();
    });
  }

  @override
  Widget build(BuildContext context) {
    BreathingExerciseViewModel breathingExerciseVM =
        Provider.of<BreathingExerciseViewModel>(context);

    return Scaffold(
        appBar: CustomAppBar(
          title: widget.breathingExerciseDatatype.exerciseName,
        ),
        body: getFragment(breathingExerciseVM));
  }

  Widget getFragment(BreathingExerciseViewModel breathingExerciseVM) {
    switch (breathingExerciseVM.getPageState()) {
      case BreathingPageState.CONFIG:
        return const BreathingConfigFragment();
      case BreathingPageState.EXERCISE:
        return BreathingExerciseFragment(
          exerciseDuration:
              Duration(minutes: breathingExerciseVM.getMinutesCounter()),
          inspirationDuration:
              widget.breathingExerciseDatatype.inspirationDuration,
          holdingDuration: widget.breathingExerciseDatatype.holdingDuration,
          expirationDuration:
              widget.breathingExerciseDatatype.expirationDuration,
          additionalInformation:
              widget.breathingExerciseDatatype.additionalInfo,
        );
      case BreathingPageState.FINISH:
        return const BreathingFinishFragment();
      default:
        return const BreathingConfigFragment();
    }
  }
}
