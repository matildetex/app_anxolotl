import 'package:anxolotl_app/src/data/services/health_profile/utils.dart';
import 'package:anxolotl_app/src/lang/anxolotl_localizations.dart';
import 'package:anxolotl_app/src/ui/datatypes/overview_datatypes.dart';
import 'package:anxolotl_app/src/util/aesthetics/design_theme.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class DataOverviewBarChart extends StatefulWidget {
  const DataOverviewBarChart(
      {super.key,
      required this.title,
      required this.monthlyData,
      required this.valueInterval});
  final Iterable<OverviewDataType> monthlyData;
  final ValueInterval<double> valueInterval;
  final String title;

  @override
  State<StatefulWidget> createState() => DataOverviewBarChartState();
}

class DataOverviewBarChartState extends State<DataOverviewBarChart> {
  late List<OverviewDataType> monthlyDataList;
  static const int maxDays = 28;

  @override
  Widget build(BuildContext context) {
    double valueAmplitude = widget.valueInterval.max - widget.valueInterval.min;
    double maxValueWithMargin =
        widget.valueInterval.max + valueAmplitude * 0.05;

    monthlyDataList = widget.monthlyData.toList();
    monthlyDataList.sort((OverviewDataType entry0, OverviewDataType entry1) =>
        entry0.date.compareTo(entry1.date));
    monthlyDataList = monthlyDataList.sublist(
        monthlyDataList.length - maxDays, monthlyDataList.length);

    TextStyle? menuStyle = Theme.of(context).textTheme.titleLarge;
    TextStyle? body2Style = Theme.of(context).textTheme.titleMedium;

    return AspectRatio(
      aspectRatio: 1.4,
      child: Card(
          margin: const EdgeInsets.all(DesignTheme.singlePadding),
          color: Theme.of(context).colorScheme.surface,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(DesignTheme.doublePadding),
                child: Text(
                  widget.title,
                  style: menuStyle,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: DesignTheme.doublePadding),
                child: Text(
                  LocalizationsUtil.l10n(context)
                      .lastDaysExp(monthlyDataList.length),
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
          )),
    );
  }

  Widget getTitles(double value, TitleMeta meta) {
    TextStyle? bodySmallStyle = Theme.of(context).textTheme.bodySmall;
    String text;
    final intVal = value.toInt();

    if (intVal == 0) {
      text = LocalizationsUtil.dateTimeDayString(
          monthlyDataList.first.date, context);
    } else if (intVal == maxDays ~/ 2) {
      text = LocalizationsUtil.dateTimeDayString(
          monthlyDataList[maxDays ~/ 2].date, context);
    } else if (intVal == maxDays - 1) {
      text = LocalizationsUtil.dateTimeDayString(
          monthlyDataList[maxDays - 1].date, context);
    } else {
      text = '';
    }
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

  FlBorderData get borderData => FlBorderData(
        show: false,
      );

  Widget rightTitles(double value, TitleMeta meta) {
    TextStyle? bodySmallStyle = Theme.of(context).textTheme.bodySmall;
    String text;

    int meanValue = (widget.valueInterval.max - widget.valueInterval.min) ~/ 2;

    if (value == widget.valueInterval.min.toInt()) {
      text = widget.valueInterval.min.toInt().toString();
    } else if (value == widget.valueInterval.max.toInt()) {
      text = widget.valueInterval.max.toInt().toString();
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
    DateTime oldestDate = monthlyDataList.first.date;
    return monthlyDataList.map((OverviewDataType dataPoint) {
      return BarChartGroupData(
        x: dataPoint.date.difference(oldestDate).inDays,
        barRods: [
          BarChartRodData(
            color: Theme.of(context).colorScheme.primary,
            toY: dataPoint.value,
          )
        ],
      );
    });
  }
}
