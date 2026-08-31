import 'package:anxolotl_app/src/lang/anxolotl_localizations.dart';
import 'package:anxolotl_app/src/ui/datatypes/exercise_datatype.dart';
import 'package:anxolotl_app/src/ui/view/breathing_exercise/breathing_exercise_page.dart';
import 'package:anxolotl_app/src/ui/view/landing/widgets/exercise_card.dart';
import 'package:anxolotl_app/src/ui/view/meditation_exercise/meditation_exercise_page.dart';
import 'package:anxolotl_app/src/ui/viewmodels/breathing_exercise_vm.dart';
import 'package:anxolotl_app/src/ui/viewmodels/meditation_exercise_vm.dart';
import 'package:anxolotl_app/src/util/aesthetics/design_theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WellBeingFragment extends StatefulWidget {
  const WellBeingFragment({super.key});

  @override
  State<WellBeingFragment> createState() => _WellBeingFragmentState();
}

class _WellBeingFragmentState extends State<WellBeingFragment> {
  @override
  Widget build(BuildContext context) {
    TextStyle? h3Style = Theme.of(context).textTheme.displaySmall;

    BreathingExerciseViewModel breathingExerciseVM =
        Provider.of<BreathingExerciseViewModel>(context);

    MeditationExerciseViewModel meditationExerciseVM =
        Provider.of<MeditationExerciseViewModel>(context);

    return Scaffold(
        //backgroundColor: Colors.amberAccent,
        body: SafeArea(
            child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                controller: ScrollController(),
                padding: const EdgeInsets.symmetric(
                    horizontal: DesignTheme.singlePadding,
                    vertical: DesignTheme.singlePadding),
                children: [
          Padding(
            padding: const EdgeInsets.only(left: 15, bottom: 5),
            child: Text(
              LocalizationsUtil.l10n(context).exercises,
              style: h3Style,
            ),
          ),
          ...breathingExerciseVM
              .getBreathingExercises(context)
              .map((BreathingExerciseDatatype entry) => ExerciseCard(
                  exerciseInfo: entry,
                  exerciseNewPage: BreathingExercisePage(
                    breathingExerciseDatatype: entry,
                  ))),
          Padding(
            padding: const EdgeInsets.only(left: 15, bottom: 5, top: 15),
            child: Text(
              LocalizationsUtil.l10n(context).mindfulness,
              style: h3Style,
            ),
          ),
          ...meditationExerciseVM.getMeditationExercises(context).map(
                (MeditationExerciseDatatype entry) => ExerciseCard(
                    exerciseInfo: entry,
                    exerciseNewPage: MeditationExerciseView(
                        meditationExerciseDatatype: entry)),
              )
        ])));
  }
}
