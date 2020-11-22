import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:timeline_tile/timeline_tile.dart';

import '../../../common/widgets/stacked_horizontal_bar_chart.dart';
import '../fetch/bloc/fetch_stats_bloc.dart';
import '../models/models.dart';

class StatsOverviewPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return BlocBuilder<FetchStatsBloc, FetchStatsState>(
      builder: (context, state) {
        if (state is FetchStatsInitial) {
          return Center(child: SpinKitWave(color: theme.accentColor));
        } else if (state is FetchStatsFinishedState) {
          if (state.stats.length == 0) {
            return Center(
              child: Column(
                children: [
                  Text(
                    'Timeline',
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 32, color: Colors.white),
                  ),
                  SizedBox(height: 160.0),
                  Icon(
                    Icons.not_interested,
                    size: 160,
                    color: theme.colorScheme.background,
                  ),
                  Text(
                    'Empty',
                    style: theme.textTheme.headline1,
                  ),
                  Text(
                    'Add or import an activity with the action button in the bottom right corner',
                    style: theme.textTheme.caption,
                  ),
                ],
              ),
            );
          }
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: <Widget>[
                  Text(
                    'Timeline',
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 32, color: Colors.white),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: CustomScrollView(
                      slivers: <Widget>[
                        _buildSlivers(state, theme),
                        const SliverPadding(padding: EdgeInsets.only(top: 20)),
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        } else {
          return Center(child: Text('Unknown state $state'));
        }
      },
    );
  }

  Widget _buildSlivers(FetchStatsFinishedState state, ThemeData theme) {
    return SliverList(
      delegate: SliverChildListDelegate(
        <Widget>[
          Container(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                for (var i = 0; i < state.stats.length; i++)
                  _buildTimelineTile(i, state.stats.length - 1,
                      state.stats[state.stats.keys.elementAt(i)], theme)
              ],
            ),
          ),
        ],
      ),
    );
  }

  TimelineTile _buildTimelineTile(
    int i,
    int length,
    List<UserStat> stats,
    ThemeData theme,
  ) {
    int total = 0;
    stats.forEach((element) => total += element.total ~/ 60);

    String formattedDate = DateFormat('yyyy MMMM').format(
      DateTime.parse(stats[0].period),
    );

    return TimelineTile(
      alignment: TimelineAlign.manual,
      lineXY: 0.75,
      isFirst: i == 0,
      isLast: i == length,
      indicatorStyle: IndicatorStyle(width: 15),
      startChild: Container(
        constraints: const BoxConstraints(minHeight: 120),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: StackedHorizontalSingleBarChart.withActivityData(stats),
        ),
      ),
      endChild: Container(
        constraints: const BoxConstraints(minHeight: 120),
        alignment: Alignment.bottomLeft,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                formattedDate,
                textAlign: TextAlign.start,
                style: theme.textTheme.headline6,
              ),
              Text(
                'Active for $total minutes',
                style: theme.textTheme.caption,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
