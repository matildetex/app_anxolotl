import 'package:anxolotl_app/src/lang/anxolotl_localizations.dart';
import 'package:anxolotl_app/src/ui/viewmodels/breathing_exercise_vm.dart';
import 'package:anxolotl_app/src/util/phone_info.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BreathingConfigFragment extends StatefulWidget {
  const BreathingConfigFragment({super.key});

  @override
  State<BreathingConfigFragment> createState() =>
      _BreathingConfigFragmentState();
}

class _BreathingConfigFragmentState extends State<BreathingConfigFragment> {
  @override
  Widget build(BuildContext context) {
    BreathingExerciseViewModel breathingExerciseVM =
        Provider.of<BreathingExerciseViewModel>(context);
    double phoneScreenWidth = PhoneInfo.getScreenWidth(context);
    int fabNumber = 0;

    TextStyle? h2Style = Theme.of(context).textTheme.displayMedium;
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        const Spacer(
          flex: 2,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
                width: phoneScreenWidth / 1.4,
                height: phoneScreenWidth / 1.4,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Theme.of(context).colorScheme.outline,
                    width: 12,
                  ),
                ),
                child: Center(
                  child: Text(
                    LocalizationsUtil.l10n(context).minutes(
                        breathingExerciseVM.getMinutesCounter(),
                        "${breathingExerciseVM.getMinutesCounter()}"),
                    style: h2Style,
                  ),
                ))
          ],
        ),
        const Spacer(
          flex: 1,
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Spacer(
              flex: 1,
            ),
            FloatingActionButton(
              heroTag: "${runtimeType}_${fabNumber++}",
              onPressed: () => breathingExerciseVM.addToMinutesCounter(-1),
              backgroundColor: Theme.of(context).colorScheme.outline,
              child: const Icon(Icons.chevron_left_outlined),
            ),
            const Spacer(
              flex: 2,
            ),
            FloatingActionButton(
              heroTag: "${runtimeType}_${fabNumber++}",
              onPressed: () => breathingExerciseVM.addToMinutesCounter(1),
              backgroundColor: Theme.of(context).colorScheme.outline,
              child: const Icon(Icons.chevron_right_outlined),
            ),
            const Spacer(
              flex: 1,
            ),
          ],
        ),
        const Spacer(
          flex: 2,
        ),
        SizedBox(
          height: 80.0,
          width: 80.0,
          child: FittedBox(
            child: FloatingActionButton(
              heroTag: "${runtimeType}_${fabNumber++}",
              onPressed: () => breathingExerciseVM.nextPageState(),
              child: const Icon(Icons.play_arrow_outlined),
            ),
          ),
        ),
        const Spacer(
          flex: 1,
        ),
      ],
    );
  }
}
