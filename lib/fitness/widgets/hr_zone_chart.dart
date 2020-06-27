import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:lifelog/fitness/activity/models/activity.dart';
import 'package:lifelog/fitness/activity/models/heart_rate_zone_data.dart';

import 'indicator.dart';

class HRZonesPieChart extends StatefulWidget {
  final Activity a;
  HRZonesPieChart(this.a);

  @override
  _HRZonesPieChartState createState() => _HRZonesPieChartState(a);
}

class _HRZonesPieChartState extends State<HRZonesPieChart> {
  final Activity _a;
  double per;
  double z1;
  double z2;
  double z3;
  double z4;
  double z5;
  double titleOffset = 0.5;

  _HRZonesPieChartState(this._a);

  @override
  void initState() {
    super.initState();
    per = 100 / _a.heartRateZoneData.numEntries;
    z1 = per * _a.heartRateZoneData.zone1;
    z2 = per * _a.heartRateZoneData.zone2;
    z3 = per * _a.heartRateZoneData.zone3;
    z4 = per * _a.heartRateZoneData.zone4;
    z5 = per * _a.heartRateZoneData.zone5;
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return Container(
      height: 200,
      width: 300,
      child: Row(
        children: <Widget>[
          _buildPieChart(theme),
          const SizedBox(width: 16.0),
          _buildIndicatorColumn(theme),
        ],
      ),
    );
  }

  Container _buildPieChart(ThemeData theme) {
    var titleStyle = theme.textTheme.headline6.copyWith(
      color: Colors.white,
      fontWeight: FontWeight.bold,
      fontSize: 20,
      shadows: [Shadow(blurRadius: 2.0, color: Colors.black)],
    );

    return Container(
      height: 200,
      width: 200,
      child: Stack(
        children: [
          Align(
              child: Text(
            'Heart\nRate (%)',
            style: theme.textTheme.headline5,
            textAlign: TextAlign.center,
          )),
          PieChart(
            PieChartData(
              startDegreeOffset: 180,
              borderData: FlBorderData(show: false),
              // centerSpaceRadius: r - 10,
              sectionsSpace: 3,
              sections: [
                PieChartSectionData(
                  color: HRZoneColors.zone1,
                  title: z1.toInt().toString(),
                  titleStyle: titleStyle,
                  value: z1,
                  titlePositionPercentageOffset: titleOffset,
                ),
                PieChartSectionData(
                  color: HRZoneColors.zone2,
                  title: z2.toInt().toString(),
                  titleStyle: titleStyle,
                  value: z2,
                  titlePositionPercentageOffset: titleOffset,
                ),
                PieChartSectionData(
                  color: HRZoneColors.zone3,
                  title: z3.toInt().toString(),
                  titleStyle: titleStyle,
                  value: z3,
                  titlePositionPercentageOffset: titleOffset,
                ),
                PieChartSectionData(
                  color: HRZoneColors.zone4,
                  title: z4.toInt().toString(),
                  titleStyle: titleStyle,
                  value: z4,
                  titlePositionPercentageOffset: titleOffset,
                ),
                PieChartSectionData(
                  color: HRZoneColors.zone5,
                  title: z5.toInt().toString(),
                  titleStyle: titleStyle,
                  value: z5,
                  titlePositionPercentageOffset: titleOffset,
                ),
              ],
            ),
            swapAnimationDuration: const Duration(milliseconds: 250),
          )
        ],
      ),
    );
  }

  Widget _buildIndicatorColumn(ThemeData theme) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Indicator(color: HRZoneColors.zone1, text: 'Zone 1', isSquare: true),
        const SizedBox(height: 4),
        Indicator(color: HRZoneColors.zone2, text: 'Zone 2', isSquare: true),
        const SizedBox(height: 4),
        Indicator(color: HRZoneColors.zone3, text: 'Zone 3', isSquare: true),
        const SizedBox(height: 4),
        Indicator(color: HRZoneColors.zone4, text: 'Zone 4', isSquare: true),
        const SizedBox(height: 4),
        Indicator(color: HRZoneColors.zone5, text: 'Zone 5', isSquare: true),
      ],
    );
  }
}
