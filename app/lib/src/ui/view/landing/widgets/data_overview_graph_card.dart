import 'package:anxolotl_app/src/data/services/health_profile/utils.dart';
import 'package:anxolotl_app/src/lang/anxolotl_localizations.dart';
import 'package:anxolotl_app/src/ui/datatypes/overview_datatypes.dart';
import 'package:anxolotl_app/src/util/aesthetics/design_theme.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class DataOverviewGraphCard extends StatefulWidget {
  const DataOverviewGraphCard(
      {super.key,
      required this.title,
      required this.todayValues,
      required this.graphValues});

  final String title;
  final OverviewDataType todayValues;
  final Iterable<OverviewDataType> graphValues;

  @override
  State<DataOverviewGraphCard> createState() => _DataOverviewGraphCardState();
}

class _DataOverviewGraphCardState extends State<DataOverviewGraphCard> {
  @override
  Widget build(BuildContext context) {
    TextStyle? bodySmallStyle = Theme.of(context).textTheme.bodySmall;
    TextStyle? subHeaderStyle = Theme.of(context).textTheme.titleLarge;
    TextStyle? headlineMediumStyle = Theme.of(context).textTheme.headlineMedium;

    return Card(
      child: InkWell(
//onTap: () => Navigator.of(context).push(SlideRightRoute(page: )),
          onTap: () => {},
          //Navigator.of(context).push(SlideRightRoute(page: widget.nextPage)),
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
                            widget.title,
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
                                widget.todayValues.date, context),
                            textAlign: TextAlign.start,
                            style: bodySmallStyle,
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: DesignTheme.singlePadding,
                      ),
                      Text(
                        textAlign: TextAlign.start,
                        widget.todayValues.value.toInt().toString(),
                        style: headlineMediumStyle,
                      ),
                    ],
                  )),
              const SizedBox(
                height: DesignTheme.doublePadding,
              ),
              DataOverviewGraphCardGraphChart(
                temporalData: widget.graphValues.toList(),
              )
            ],
          )),
    );
  }
}

class DataOverviewGraphCardGraphChart extends StatefulWidget {
  const DataOverviewGraphCardGraphChart({super.key, required this.temporalData});
  final List<OverviewDataType> temporalData;

  @override
  State<StatefulWidget> createState() => DataOverviewGraphCardGraphChartState();
}

class DataOverviewGraphCardGraphChartState
    extends State<DataOverviewGraphCardGraphChart> {
  late List<OverviewDataType> temporalData;

  static const maxDays = 7;
  late final ValueInterval<double> valueInterval;

  @override
  void initState() {
    temporalData = widget.temporalData;

    Iterable<double> monthlyDataListValues = temporalData.map((e) => e.value);
    double maxValue =
        monthlyDataListValues.reduce((curr, next) => curr > next ? curr : next);
    valueInterval = ValueInterval(0, maxValue > 2 ? maxValue : 2);
  }

  @override
  Widget build(BuildContext context) {
    double valueAmplitude = valueInterval.max - valueInterval.min;
    double maxValueWithMargin = valueInterval.max + valueAmplitude * 0.05;

    temporalData = widget.temporalData.toList();
    temporalData.sort((OverviewDataType entry0, OverviewDataType entry1) =>
        entry0.date.compareTo(entry1.date));
    temporalData = temporalData.sublist(
        temporalData.length - maxDays, temporalData.length);

    TextStyle? menuStyle = Theme.of(context).textTheme.titleLarge;
    TextStyle? body2Style = Theme.of(context).textTheme.titleMedium;

    return AspectRatio(
      aspectRatio: 2.9,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: DesignTheme.doublePadding),
            child: Text(
              LocalizationsUtil.l10n(context).lastDaysExp(temporalData.length),
              style: body2Style,
            ),
          ),
          Flexible(
            child: BarChart(
              BarChartData(
                titlesData: titlesData,
                borderData: borderData,
                barGroups: barGraphData.toList(),
                barTouchData: BarTouchData(enabled: false),
                gridData: const FlGridData(show: true, drawVerticalLine: false),
                alignment: BarChartAlignment.spaceAround,
                maxY: maxValueWithMargin,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget getTitles(double value, TitleMeta meta) {
    TextStyle? bodySmallStyle = Theme.of(context).textTheme.bodySmall;
    String text;

    final int index = value.toInt();

    if (index == 0 && temporalData.isNotEmpty) {
      text = LocalizationsUtil.dateTimeDayString(
          temporalData.first.date, context);
    } else if (index == maxDays ~/ 2 && temporalData.length > (maxDays ~/ 2)) {
      text = LocalizationsUtil.dateTimeDayString(
          temporalData[maxDays ~/ 2].date, context);
    } else if (index == maxDays - 1 && temporalData.length > (maxDays - 1)) {
      text = LocalizationsUtil.dateTimeDayString(
          temporalData[maxDays - 1].date, context);
    } else {
      text = '';
    }

    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 4,
      child: Text(text, style: bodySmallStyle),
    );
    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 4,
      child: Text(text, style: bodySmallStyle),
    );
  }

  FlTitlesData get titlesData => FlTitlesData(
      show: true,
      bottomTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          reservedSize: DesignTheme.triplePadding,
          getTitlesWidget: getTitles,
        ),
      ),
      leftTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          reservedSize: DesignTheme.doublePadding,
          interval: 1,
          getTitlesWidget: (a, b) => Container(),
        ),
      ),
      topTitles: const AxisTitles(
        sideTitles: SideTitles(showTitles: true, reservedSize: 0),
      ),
      rightTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          reservedSize: DesignTheme.doublePadding * 2,
          interval: 1,
          getTitlesWidget: rightTitles,
        ),
      ));

  FlBorderData get borderData => FlBorderData(show: false);

  Widget rightTitles(double value, TitleMeta meta) {
    TextStyle? bodySmallStyle = Theme.of(context).textTheme.bodySmall;
    String text;

    int meanValue = (valueInterval.max - valueInterval.min) ~/ 2;

    if (value == valueInterval.min.toInt()) {
      text = valueInterval.min.toInt().toString();
    } else if (value == valueInterval.max.toInt()) {
      text = valueInterval.max.toInt().toString();
    } else if (value == meanValue) {
      text = meanValue.toString();
    } else {
      return Container();
    }
    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: DesignTheme.doublePadding,
      child: Text(text, style: bodySmallStyle),
    );
  }

  Iterable<BarChartGroupData> get barGraphData {
    DateTime oldestDate = temporalData.first.date;
    return temporalData.map((OverviewDataType dataPoint) {
      return BarChartGroupData(
        x: dataPoint.date.difference(oldestDate).inDays,
        barRods: [
          BarChartRodData(
              color: Theme.of(context).colorScheme.secondary,
              toY: dataPoint.value,
              width: DesignTheme.singlePadding * 4,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(2)))
        ],
      );
    });
  }
}
