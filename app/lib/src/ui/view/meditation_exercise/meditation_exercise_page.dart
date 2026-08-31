import 'package:anxolotl_app/src/lang/anxolotl_localizations.dart';
import 'package:anxolotl_app/src/ui/datatypes/exercise_datatype.dart';
import 'package:anxolotl_app/src/ui/view/meditation_exercise/widgets/meditation_audio_player_fragment.dart';
import 'package:anxolotl_app/src/ui/view/meditation_exercise/widgets/meditation_finish_fragment.dart';
import 'package:anxolotl_app/src/ui/viewmodels/meditation_exercise_vm.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MeditationExerciseView extends StatefulWidget {
  const MeditationExerciseView(
      {super.key, required this.meditationExerciseDatatype});
  final MeditationExerciseDatatype meditationExerciseDatatype;

  @override
  State<MeditationExerciseView> createState() => _MeditationExerciseViewState();
}

class _MeditationExerciseViewState extends State<MeditationExerciseView> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      MeditationExerciseViewModel meditationExerciseVM =
          Provider.of<MeditationExerciseViewModel>(context, listen: false);
      meditationExerciseVM.resetMeditationExerciseState();
    });
  }

  @override
  Widget build(BuildContext context) {
    TextStyle? h2Style = Theme.of(context).textTheme.displayMedium;

    MeditationExerciseViewModel meditationExerciseVM =
        Provider.of<MeditationExerciseViewModel>(context);

    return Scaffold(
        appBar: AppBar(
            elevation: 0,
            title: AutoSizeText(
              LocalizationsUtil.l10n(context).mindfulnessExercise,
              maxLines: 1,
              minFontSize: 12,
              style: h2Style,
            )),
        body: Center(
            child: meditationExerciseVM.isExerciseStateFinish()
                ? const MeditationFinishFragment()
                : MeditationAudioPlayerFragment(
                    meditationExerciseDatatype:
                        widget.meditationExerciseDatatype,
                  )));
  }
}
