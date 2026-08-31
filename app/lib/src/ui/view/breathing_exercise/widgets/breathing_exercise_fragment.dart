import 'dart:async';
import 'dart:ui';

import 'package:anxolotl_app/src/lang/anxolotl_localizations.dart';
import 'package:anxolotl_app/src/ui/viewmodels/breathing_exercise_vm.dart';
import 'package:anxolotl_app/src/util/aesthetics/design_theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

class BreathingExerciseFragment extends StatefulWidget {
  const BreathingExerciseFragment(
      {super.key,
      required this.exerciseDuration,
      required this.inspirationDuration,
      required this.holdingDuration,
      required this.expirationDuration,
      this.additionalInformation = ""});
  final Duration exerciseDuration;
  final Duration inspirationDuration;
  final Duration holdingDuration;
  final Duration expirationDuration;
  final String additionalInformation;

  @override
  State<BreathingExerciseFragment> createState() =>
      _BreathingExerciseFragmentState();
}

class _BreathingExerciseFragmentState extends State<BreathingExerciseFragment>
    with SingleTickerProviderStateMixin {
  late Animation<double> animation;
  late AnimationController animationController;

  String action = "";
  double circleDiameter = window.physicalSize.shortestSide / 3;

  @override
  void initState() {
    super.initState();
    BreathingExerciseViewModel? breathingExerciseVM;
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      breathingExerciseVM =
          Provider.of<BreathingExerciseViewModel>(context, listen: false);
    });

    animationController = AnimationController(
        vsync: this,
        duration: widget.inspirationDuration,
        reverseDuration: widget.expirationDuration);
    //here we have to vash vsync argument, there for we use "with SingleTickerProviderStateMixin" above
    //vsync is the ThickerProvider, and set duration of animation

    //Max used size is defined in the container
    animation = Tween<double>(begin: 100, end: circleDiameter)
        .animate(animationController)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          action = LocalizationsUtil.l10n(context).holdBreath;
          Future.delayed(widget.holdingDuration).then((value) {
            animationController.reverse();
            action = LocalizationsUtil.l10n(context).exhale;
          });
        } else if (status == AnimationStatus.dismissed) {
          breathingExerciseVM!.increaseBreathCounter();
          if (breathingExerciseVM!.breathingExerciseFinished()) {
            breathingExerciseVM!.nextPageState();
          }
          animationController.forward();
          action = LocalizationsUtil.l10n(context).inhale;
        }
      });
    //set the begin value and end value, we will use this value for height and width of circle

    animation.addListener(() {
      setState(() {});
    });
  }

  @override
  void deactivate() {
    BreathingExerciseViewModel breathingExerciseVM =
        Provider.of<BreathingExerciseViewModel>(context);
    breathingExerciseVM.resetPageState();
    breathingExerciseVM.resetBreathingExerciseState();
    animationController.dispose(); //destroy animation to free memory on last
  }

  @override
  Widget build(BuildContext context) {
    TextStyle? h2Style = Theme.of(context).textTheme.displayMedium;

    BreathingExerciseViewModel breathingExerciseVM =
        Provider.of<BreathingExerciseViewModel>(context);

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        const Spacer(
          flex: 2,
        ),
        Text(widget.additionalInformation),
        Container(
          padding: const EdgeInsets.all(DesignTheme.doublePadding),
          alignment: Alignment.center,
          height: circleDiameter + 20,
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle, //making box to circle
              color: Theme.of(context)
                  .colorScheme
                  .primary, //background of container
            ),
            height: animation.value, //value from animation controller
            width: animation.value, //value from animation controller
          ),
        ),
        const Spacer(flex: 1),
        breathingExerciseVM.getBreathingExerciseState() !=
                BreathingExerciseState.WAITING
            ? Text(
                action,
                style: h2Style,
              )
            : ElevatedButton(
                onPressed: () => setState(() {
                  breathingExerciseVM.nextBreathingExerciseState();
                  action = LocalizationsUtil.l10n(context).inhale;
                  animationController.forward();
                  WakelockPlus.enable();
                  Timer(widget.exerciseDuration, () {
                    breathingExerciseVM.nextBreathingExerciseState();
                    WakelockPlus.disable();
                  });
                }),
                child: Text(LocalizationsUtil.l10n(context).start),
              ),
        const Spacer(flex: 3),
      ],
    );
  }
}
