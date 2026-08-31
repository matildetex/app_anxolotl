import 'package:anxolotl_app/src/data/model/user/health_events.dart';
import 'package:anxolotl_app/src/lang/anxolotl_localizations.dart';
import 'package:anxolotl_app/src/ui/view/landing/widgets/event_detail_card.dart';
import 'package:anxolotl_app/src/ui/viewmodels/health_events_vm.dart';
import 'package:anxolotl_app/src/util/aesthetics/design_theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EventsFragment extends StatefulWidget {
  const EventsFragment({super.key, required this.changeToWellbeingPage});

  final void Function() changeToWellbeingPage;
  @override
  State<EventsFragment> createState() => _EventsFragmentState();
}

class _EventsFragmentState extends State<EventsFragment> {
  @override
  Widget build(BuildContext context) {
    HealthEventsViewModel healthNotificationsVM =
        Provider.of<HealthEventsViewModel>(context);

    return Scaffold(
        //backgroundColor: Colors.amberAccent,
        body: Padding(
            padding: const EdgeInsets.all(DesignTheme.singlePadding),
            child: healthNotificationsVM.readHealthNotifications().isEmpty
                ? noAvailableNotifications(context)
                : presentNotifications(healthNotificationsVM)));
  }

  Widget noAvailableNotifications(BuildContext context) {
    TextStyle? subHeaderStyle = Theme.of(context).textTheme.titleLarge;

    return Center(
        child: Text(
      LocalizationsUtil.l10n(context).noHealthNotifications,
      style: subHeaderStyle,
    ));
  }

  Widget presentNotifications(HealthEventsViewModel healthNotificationsVM) {
    return Center(
        child: ListView(
      children: [
        ...healthNotificationsVM
            .readHealthNotifications()
            .map((HealthEvent healthEvent) => EventDetailCard(
                  healthEventDetail: healthNotificationsVM
                      .getHealthEventDatatype(healthEvent.healthEventReason),
                  healthEvent: healthEvent,
                  currentDatetime: DateTime.fromMillisecondsSinceEpoch(
                      healthEvent.timestamp),
                  changePage: widget.changeToWellbeingPage,
                ))
      ],
    ));
  }
}
