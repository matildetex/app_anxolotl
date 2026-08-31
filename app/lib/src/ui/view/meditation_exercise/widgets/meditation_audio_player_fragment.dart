import 'package:anxolotl_app/src/ui/datatypes/exercise_datatype.dart';
import 'package:anxolotl_app/src/ui/viewmodels/meditation_exercise_vm.dart';
import 'package:anxolotl_app/src/util/aesthetics/design_theme.dart';
import 'package:anxolotl_app/src/util/phone_info.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MeditationAudioPlayerFragment extends StatefulWidget {
  const MeditationAudioPlayerFragment(
      {super.key, required this.meditationExerciseDatatype});
  final MeditationExerciseDatatype meditationExerciseDatatype;

  @override
  State<MeditationAudioPlayerFragment> createState() =>
      _MeditationAudioPlayerFragmentState();
}

class _MeditationAudioPlayerFragmentState
    extends State<MeditationAudioPlayerFragment> {
  AudioPlayer audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();

    initializeAudioPlayer();

    MeditationExerciseViewModel? meditationExerciseVM;
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      meditationExerciseVM =
          Provider.of<MeditationExerciseViewModel>(context, listen: false);

      audioPlayer.onPlayerStateChanged.listen((PlayerState event) {
        switch (event) {
          case PlayerState.playing:
            meditationExerciseVM!
                .changePlayingState(MeditationExercisePlayerState.PLAYING);
            break;
          case PlayerState.paused:
            meditationExerciseVM!
                .changePlayingState(MeditationExercisePlayerState.PAUSED);
            break;
          case PlayerState.completed:
          case PlayerState.stopped:
            meditationExerciseVM!.resetPlayer();
            break;
          default:
            break;
        }
      });
      audioPlayer.onPositionChanged.listen((Duration newDuration) {
        meditationExerciseVM!.changeMusicCurrentPosition(newDuration);
      });
    });
    audioPlayer.onPlayerComplete.listen((event) {
      meditationExerciseVM!.advanceExerciseState();
    });
  }

  Future initializeAudioPlayer() async {
    audioPlayer.audioCache = AudioCache(prefix: "");
    await audioPlayer.setSource(
        AssetSource(widget.meditationExerciseDatatype.meditationPath));
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double phoneScreenHeight = PhoneInfo.getScreenHeight(context);
    double phoneScreenWidth = PhoneInfo.getScreenWidth(context);
    TextStyle? h3Style = Theme.of(context).textTheme.displaySmall;
    TextStyle? body1Style = Theme.of(context).textTheme.bodyLarge;

    MeditationExerciseViewModel meditationExerciseVM =
        Provider.of<MeditationExerciseViewModel>(context);

    return Padding(
        padding: const EdgeInsets.all(DesignTheme.singlePadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Spacer(
              flex: 4,
            ),
            Center(
                child: ClipRRect(
                    borderRadius:
                        BorderRadius.circular(DesignTheme.roundedCornersRadius),
                    child: Container(
                        height: phoneScreenHeight / 2.5,
                        width: phoneScreenWidth / 1.1,
                        color: Theme.of(context).colorScheme.secondary,
                        child: Image(
                          image: AssetImage(widget
                              .meditationExerciseDatatype.illustrationPath),
                          //fit: BoxFit.fitHeight,
                        )))),
            Text(
              widget.meditationExerciseDatatype.exerciseName,
              style: h3Style,
            ),
            Text(
              widget.meditationExerciseDatatype.authors,
              style: body1Style,
            ),
            const Spacer(
              flex: 1,
            ),
            Slider(
              inactiveColor: Theme.of(context).colorScheme.onSurfaceVariant,
              activeColor: Theme.of(context).colorScheme.secondary,
              min: 0,
              max: widget.meditationExerciseDatatype.totalDuration.inSeconds
                  .toDouble(),
              value: meditationExerciseVM
                  .getMusicCurrentPosition()
                  .inSeconds
                  .toDouble(),
              onChanged: (double value) async {
                final newPosition = Duration(seconds: value.toInt());
                meditationExerciseVM.changeMusicCurrentPosition(newPosition);
                await audioPlayer.seek(newPosition);
              },
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: DesignTheme.singlePadding),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(formatTime(
                      meditationExerciseVM.getMusicCurrentPosition())),
                  Text(formatTime(
                      widget.meditationExerciseDatatype.totalDuration))
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            CircleAvatar(
              radius: 35,
              backgroundColor: Theme.of(context).colorScheme.onSurfaceVariant,
              child: IconButton(
                color: Theme.of(context).colorScheme.onPrimary,
                icon: Icon(meditationExerciseVM.isPlayerPlaying()
                    ? Icons.pause
                    : Icons.play_arrow),
                iconSize: 50,
                onPressed: () async => meditationExerciseVM.isPlayerPlaying()
                    ? await audioPlayer.pause()
                    : await audioPlayer.resume(),
              ),
            ),
            const Spacer(
              flex: 3,
            ),
          ],
        ));
  }

  String formatTime(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return [if (duration.inHours > 0) hours, minutes, seconds].join(":");
  }
}
