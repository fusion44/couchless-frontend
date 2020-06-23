import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class GaugeChart extends StatelessWidget {
  final double value;
  final double max;
  final Color mainColor;
  final Color secondaryColor;

  const GaugeChart({
    Key key,
    @required this.value,
    @required this.max,
    this.mainColor,
    this.secondaryColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PieChart(
      _buildTrainingEffectChartData(Theme.of(context)),
      swapAnimationDuration: const Duration(milliseconds: 250),
    );
  }

  PieChartData _buildTrainingEffectChartData(ThemeData theme) {
    return PieChartData(
      borderData: FlBorderData(show: false),
      startDegreeOffset: 180,
      sections: [
        PieChartSectionData(
          showTitle: false,
          value: value,
          color: mainColor,
        ),
        PieChartSectionData(
          showTitle: false,
          value: max - value,
          color: secondaryColor,
        ),
        PieChartSectionData(
          // This section "hides" the lower part of the chart
          value: max,
          color: theme.canvasColor,
          showTitle: false,
        ),
      ],
    );
  }
}
