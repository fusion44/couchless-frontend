import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';

import '../../fitness/stats/models/models.dart';
import '../sport_utils.dart';

class StackedHorizontalSingleBarChart extends StatelessWidget {
  final List<charts.Series<_ActivityDuration, String>> seriesList;
  final bool animate;

  StackedHorizontalSingleBarChart(this.seriesList, {this.animate});

  factory StackedHorizontalSingleBarChart.withActivityData(
      List<UserStat> stats) {
    final data = stats
        .map(
          (e) => charts.Series<_ActivityDuration, String>(
            id: "${e.period}-${e.sportType}",
            labelAccessorFn: (datum, index) => datum.activity,
            domainFn: (_ActivityDuration adur, _) => "",
            measureFn: (_ActivityDuration adur, _) => adur.duration,
            fillColorFn: (adur, _) => charts.ColorUtil.fromDartColor(
              getColorForSport(adur.activity),
            ),
            data: [_ActivityDuration(e.sportType, e.total ~/ 60)],
          ),
        )
        .toList();

    return StackedHorizontalSingleBarChart(data);
  }

  @override
  Widget build(BuildContext context) {
    return charts.BarChart(
      seriesList,
      animate: animate,
      barGroupingType: charts.BarGroupingType.stacked,
      vertical: false,
      domainAxis: charts.OrdinalAxisSpec(renderSpec: charts.NoneRenderSpec()),
      primaryMeasureAxis: _getPrimaryMeasureAxisSpec(),
      layoutConfig: charts.LayoutConfig(
        leftMarginSpec: charts.MarginSpec.fixedPixel(5),
        topMarginSpec: charts.MarginSpec.fixedPixel(5),
        rightMarginSpec: charts.MarginSpec.fixedPixel(5),
        bottomMarginSpec: charts.MarginSpec.fixedPixel(5),
      ),
      barRendererDecorator: charts.BarLabelDecorator<String>(
        labelPosition: charts.BarLabelPosition.inside,
        insideLabelStyleSpec: charts.TextStyleSpec(
          color: charts.MaterialPalette.black,
        ),
      ),
    );
  }

  charts.AxisSpec<num> _getPrimaryMeasureAxisSpec() {
    return charts.AxisSpec<num>(
      renderSpec: charts.SmallTickRendererSpec<num>(
        labelStyle: charts.TextStyleSpec(
          color: charts.MaterialPalette.white,
        ),
      ),
    );
  }
}

class _ActivityDuration {
  final String activity;
  final int duration;

  _ActivityDuration(this.activity, this.duration);
}
