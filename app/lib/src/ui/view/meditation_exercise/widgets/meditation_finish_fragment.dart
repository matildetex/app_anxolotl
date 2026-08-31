import 'package:anxolotl_app/globals/assets_path.dart';
import 'package:anxolotl_app/src/lang/anxolotl_localizations.dart';
import 'package:anxolotl_app/src/ui/viewmodels/meditation_exercise_vm.dart';
import 'package:anxolotl_app/src/util/aesthetics/design_theme.dart';
import 'package:anxolotl_app/src/util/phone_info.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MeditationFinishFragment extends StatefulWidget {
  const MeditationFinishFragment({super.key});

  @override
  State<MeditationFinishFragment> createState() => _MeditationFinishState();
}

class _MeditationFinishState extends State<MeditationFinishFragment> {
  @override
  Widget build(BuildContext context) {
    double phoneScreenHeight = PhoneInfo.getScreenHeight(context);
    double phoneScreenWidth = PhoneInfo.getScreenWidth(context);
    TextStyle? h2Style = Theme.of(context).textTheme.displayMedium;
    TextStyle? h3Style = Theme.of(context).textTheme.displaySmall;

    MeditationExerciseViewModel meditationExerciseVM =
        Provider.of<MeditationExerciseViewModel>(context);

    return Scaffold(
        //backgroundColor: Colors.amberAccent,
        body: Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: DesignTheme.doublePadding,
          vertical: DesignTheme.singlePadding),
      child: Column(children: [
        const Spacer(
          flex: 1,
        ),
        Center(
          child: SizedBox(
            height: phoneScreenHeight / 7,
            width: phoneScreenWidth / 3,
            child: const Padding(
                padding: EdgeInsets.all(DesignTheme.singlePadding),
                child: Image(
                  image: AssetImage("${AssetsPath.BASE_ASSETS}confetti.png"),
                  fit: BoxFit.fitWidth,
                )),
          ),
        ),
        Text(
          LocalizationsUtil.l10n(context).congratulations,
          style: h2Style,
        ),
        const Spacer(
          flex: 2,
        ),
        Text(
          LocalizationsUtil.l10n(context).mindfulnessExerciseComplete(
              meditationExerciseVM
                  .getLastSessionDuration()
                  .inMinutes
                  .toString()),
          style: h3Style,
        ),
        const Spacer(
          flex: 1,
        ),
        ElevatedButton(
          onPressed: () => setState(() {
            Navigator.pop(context);
          }),
          child: Text(
            LocalizationsUtil.l10n(context).continueExp,
          ),
        ),
        const Spacer(
          flex: 3,
        ),
      ]),
    ));
  }
}
