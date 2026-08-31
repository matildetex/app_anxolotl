import 'package:anxolotl_app/src/data/model/user/health_events.dart';
import 'package:anxolotl_app/src/lang/anxolotl_localizations.dart';
import 'package:anxolotl_app/src/ui/datatypes/health_event_datatype.dart';
import 'package:anxolotl_app/src/ui/viewmodels/health_events_vm.dart';
import 'package:anxolotl_app/src/util/aesthetics/design_theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EventDetailCard extends StatefulWidget {
  const EventDetailCard({
    super.key,
    required this.healthEventDetail,
    required this.healthEvent,
    required this.currentDatetime,
    required this.changePage,
  });

  final HealthEventDatatype healthEventDetail;
  final HealthEvent healthEvent;
  final DateTime currentDatetime;
  final void Function() changePage;

  @override
  State<EventDetailCard> createState() => _EventDetailCardState();
}

class _EventDetailCardState extends State<EventDetailCard> {
  @override
  Widget build(BuildContext context) {
    TextStyle? bodySmallStyle = Theme.of(context).textTheme.bodySmall;
    TextStyle? subHeaderStyle = Theme.of(context).textTheme.titleLarge;
    TextStyle? body1Style = Theme.of(context).textTheme.bodyLarge;

    HealthEventsViewModel healthNotificationsVM =
        Provider.of<HealthEventsViewModel>(context);

    return Dismissible(
        key:
            Key("${widget.healthEvent.userId}_${widget.healthEvent.timestamp}"),
        direction: DismissDirection.startToEnd,
        onDismissed: (_) =>
            healthNotificationsVM.deleteHealthNotification(widget.healthEvent),
        child: Card(
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                    padding: const EdgeInsets.only(
                        left: DesignTheme.doublePadding,
                        right: DesignTheme.doublePadding,
                        top: DesignTheme.doublePadding),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              widget.healthEventDetail.title,
                              style: subHeaderStyle,
                              textAlign: TextAlign.start,
                              overflow: TextOverflow.ellipsis,
                              softWrap: true,
                            ),
                            const SizedBox(
                              width: DesignTheme.singlePadding,
                            ),
                            Text(
                              LocalizationsUtil.dateTimeDayString(
                                  widget.currentDatetime, context),
                              textAlign: TextAlign.start,
                              style: bodySmallStyle,
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: DesignTheme.singlePadding,
                        ),
                        Text(
                          textAlign: TextAlign.justify,
                          widget.healthEventDetail.explanation,
                          style: body1Style,
                        ),
                        const SizedBox(
                          height: DesignTheme.singlePadding,
                        ),
                        Center(
                          child: ElevatedButton(
                            onPressed: () {
                              healthNotificationsVM
                                  .deleteHealthNotification(widget.healthEvent);
                              widget.changePage();
                            },
                            child: Text(LocalizationsUtil.l10n(context)
                                .wellbeingExercisesExp),
                          ),
                        ),
                        const SizedBox(
                          height: DesignTheme.singlePadding,
                        ),
                      ],
                    )),
              ]),
        ));
  }
}
