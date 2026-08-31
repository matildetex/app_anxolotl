import 'package:anxolotl_app/src/lang/anxolotl_localizations.dart';
import 'package:anxolotl_app/src/ui/datatypes/overview_datatypes.dart';
import 'package:anxolotl_app/src/util/aesthetics/design_theme.dart';
import 'package:flutter/material.dart';

class MeasuredLevelsCard extends StatefulWidget {
  const MeasuredLevelsCard(
      {super.key,
      required this.title,
      required this.measuredLevelsDataType,
      this.showDuration = true});

  final String title;
  final MeasuredLevelsDataType measuredLevelsDataType;
  final bool showDuration;

  @override
  State<MeasuredLevelsCard> createState() => _MeasuredLevelsCardState();
}

class _MeasuredLevelsCardState extends State<MeasuredLevelsCard> {
  @override
  Widget build(BuildContext context) {
    TextStyle? menuStyle = Theme.of(context).textTheme.titleLarge;
    TextStyle? body1Style = Theme.of(context).textTheme.bodyLarge;
    TextStyle? headlineMediumStyle = Theme.of(context).textTheme.headlineMedium;

    return Card(
      child: Padding(
          padding: const EdgeInsets.all(DesignTheme.doublePadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                widget.title,
                style: menuStyle,
              ),
              const SizedBox(
                height: DesignTheme.singlePadding,
              ),
              SizedBox(
                height: 35,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                        widget.measuredLevelsDataType.value.toInt() < 0
                            ? ""
                            : widget.measuredLevelsDataType.value
                                .toInt()
                                .toString(),
                        style: headlineMediumStyle),
                    const SizedBox(
                      width: DesignTheme.singlePadding,
                    ),
                    widget.showDuration
                        ? Text(
                            widget.measuredLevelsDataType.value.toInt() < 0
                                ? LocalizationsUtil.l10n(context)
                                    .lowAnxietyLevel
                                : LocalizationsUtil.l10n(context)
                                    .duringHoursExp(widget
                                        .measuredLevelsDataType
                                        .duration
                                        .inHours),
                            style: body1Style)
                        : const Text(""),
                  ],
                ),
              )
            ],
          )),
    );
  }
}
