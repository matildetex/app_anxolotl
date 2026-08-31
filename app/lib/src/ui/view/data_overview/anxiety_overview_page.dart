import 'package:anxolotl_app/src/lang/anxolotl_localizations.dart';
import 'package:anxolotl_app/src/ui/datatypes/overview_datatypes.dart';
import 'package:anxolotl_app/src/ui/view/common_widgets/custom_app_bar.dart';
import 'package:anxolotl_app/src/ui/view/data_overview/widgets/data_overview_bar_chart.dart';
import 'package:anxolotl_app/src/ui/view/data_overview/widgets/measured_levels_card.dart';
import 'package:anxolotl_app/src/ui/viewmodels/anxiety_data_vm.dart';
import 'package:anxolotl_app/src/util/aesthetics/design_theme.dart';
import 'package:anxolotl_app/src/util/phone_info.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AnxietyOverviewPage extends StatefulWidget {
  const AnxietyOverviewPage({super.key, required this.dataName});
  final String dataName;

  @override
  State<AnxietyOverviewPage> createState() => _AnxietyOverviewPageState();
}

class _AnxietyOverviewPageState extends State<AnxietyOverviewPage> {
  @override
  Widget build(BuildContext context) {
    AnxietyDataViewModel anxietyDataVM =
        Provider.of<AnxietyDataViewModel>(context);

    double phoneScreenHeight = PhoneInfo.getScreenHeight(context);
    double phoneScreenWidth = PhoneInfo.getScreenWidth(context);

    TextStyle? h1Style = Theme.of(context).textTheme.displayLarge;
    TextStyle? titleSmallStyle = Theme.of(context).textTheme.titleSmall;

    return Scaffold(
        appBar: CustomAppBar(
          title: widget.dataName,
        ),
        body: SafeArea(
            child: ListView(children: <Widget>[
          SizedBox(
              width: phoneScreenWidth,
              height: phoneScreenHeight / 5,
              child: Column(
                children: [
                  CustomPaint(
                    painter: OpenPainter(
                        phoneScreenWidth, phoneScreenHeight, context),
                  ),
                  const Spacer(
                    flex: 3,
                  ),
                  Text(
                    LocalizationsUtil.l10n(context).mentalLevelTitle(
                        anxietyDataVM.getTodayAnxietyAverage().value.round()),
                    style: h1Style,
                  ),
                  const Spacer(
                    flex: 1,
                  ),
                  Text(
                    LocalizationsUtil.l10n(context).mentalLevelAdvice(
                        anxietyDataVM.getTodayAnxietyAverage().value.toInt()),
                    style: titleSmallStyle,
                  ),
                  const Spacer(
                    flex: 2,
                  ),
                ],
              )),
          const SizedBox(
            height: DesignTheme.doublePadding,
          ),
          DataOverviewBarChart(
            title: LocalizationsUtil.l10n(context).dailyAverageExp,
            monthlyData: anxietyDataVM.getLastMonthAnxietyValue(),
            valueInterval: anxietyDataVM.getAnxietyLevelsInterval(),
          ),
          MeasuredLevelsCard(
            title: LocalizationsUtil.l10n(context).currentLevelExp,
            measuredLevelsDataType: MeasuredLevelsDataType(
              const Duration(hours: 0),
              anxietyDataVM.getCurrentAnxietyValue().value,
            ),
            showDuration: false,
          ),
          MeasuredLevelsCard(
            title: LocalizationsUtil.l10n(context).highestLevelTodayExp,
            measuredLevelsDataType: anxietyDataVM.getTodayMaxAnxietyValues(),
          )
        ])));
  }
}

class OpenPainter extends CustomPainter {
  OpenPainter(this.phoneScreenWidth, this.phoneScreenHeight, this.buildContext);

  final double phoneScreenWidth;
  final double phoneScreenHeight;
  final BuildContext buildContext;

  @override
  void paint(Canvas canvas, Size size) {
    var paint1 = Paint()
      ..color = Theme.of(buildContext).colorScheme.inverseSurface
      ..style = PaintingStyle.fill;
    double circleWidthSide = phoneScreenWidth / 1.2;
    double circleHeightSide = phoneScreenHeight / 5;

    canvas.drawArc(
        Rect.fromLTRB(-circleWidthSide, -circleHeightSide, circleWidthSide,
            circleHeightSide),
        -3.14,
        -3.14,
        false,
        paint1);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
