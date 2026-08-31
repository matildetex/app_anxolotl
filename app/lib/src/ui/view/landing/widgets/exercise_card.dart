import 'package:anxolotl_app/src/lang/anxolotl_localizations.dart';
import 'package:anxolotl_app/src/ui/animations/page_slide_left_transition.dart';
import 'package:anxolotl_app/src/ui/datatypes/exercise_datatype.dart';
import 'package:anxolotl_app/src/util/aesthetics/design_theme.dart';
import 'package:anxolotl_app/src/util/phone_info.dart';
import 'package:flutter/material.dart';

class ExerciseCard extends StatefulWidget {
  const ExerciseCard(
      {super.key, required this.exerciseInfo, required this.exerciseNewPage});
  final ExerciseDatatype exerciseInfo;
  final Widget exerciseNewPage;

  @override
  State<ExerciseCard> createState() => _ExerciseCardState();
}

class _ExerciseCardState extends State<ExerciseCard> {
  @override
  Widget build(BuildContext context) {
    TextStyle? bodySmallStyle = Theme.of(context).textTheme.bodySmall;
    TextStyle? subHeaderStyle = Theme.of(context).textTheme.titleLarge;
    double phoneScreenHeight = PhoneInfo.getScreenHeight(context);
    double phoneScreenWidth = PhoneInfo.getScreenWidth(context);

    return Card(
      child: InkWell(
        onTap: () => Navigator.of(context)
            .push(SlideRightRoute(page: widget.exerciseNewPage)),
        child: Row(
          children: [
            Container(
              height: phoneScreenHeight / 7,
              width: phoneScreenWidth / 3,
              color: Theme.of(context).colorScheme.secondary,
              child: Padding(
                  padding: const EdgeInsets.all(DesignTheme.singlePadding),
                  child: Image(
                    image: AssetImage(widget.exerciseInfo.illustrationPath),
                    fit: BoxFit.fitWidth,
                  )),
            ),
            const Padding(
                padding: EdgeInsets.all(DesignTheme.singlePadding)),
            Container(
              height: phoneScreenHeight / 7,
              width: phoneScreenWidth / 1.9,
              padding: const EdgeInsets.only(bottom: DesignTheme.singlePadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(""),
                  Flexible(
                      child: Text(
                    widget.exerciseInfo.exerciseName,
                    //LocalizationsUtil.l10n(context).breathingGuidance,
                    style: subHeaderStyle,
                    textAlign: TextAlign.start,
                    maxLines: 4,
                    overflow: TextOverflow.visible,
                    softWrap: true,
                  )),
                  Text(
                    LocalizationsUtil.l10n(context).minutes(
                        widget.exerciseInfo.getDurationInMinutes(),
                        widget.exerciseInfo.getFullDurationString()),
                    style: bodySmallStyle,
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
