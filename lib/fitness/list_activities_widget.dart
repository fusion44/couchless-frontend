import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:latlong/latlong.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../common/sport_utils.dart';
import '../common/widgets/widgets.dart';
import 'activity/fetch/bloc/fetch_activities_bloc.dart';
import 'activity/models/models.dart';
import 'show_activity_page.dart';

class ListActivitiesWidget extends StatefulWidget {
  @override
  _ListActivitiesWidgetState createState() => _ListActivitiesWidgetState();
}

class _ListActivitiesWidgetState extends State<ListActivitiesWidget> {
  final _scrollController = ScrollController();
  final _scrollThreshold = 200.0;
  FetchActivitiesBloc _bloc;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _bloc = BlocProvider.of<FetchActivitiesBloc>(context);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return BlocBuilder<FetchActivitiesBloc, FetchActivitiesBaseState>(
      bloc: _bloc,
      builder: (context, state) {
        if (state is FetchActivitiesInitial) {
          return BottomLoader();
        } else if (state is FetchActivitiesFinishedState) {
          return ListView.separated(
            itemCount: state.hasReachedMax
                ? state.activities.length
                : state.activities.length + 1,
            controller: _scrollController,
            itemBuilder: (BuildContext context, int index) {
              return index >= state.activities.length
                  ? BottomLoader()
                  : _buildListTile(theme, state.activities[index]);
            },
            separatorBuilder: (context, i) => Divider(),
          );
        } else if (state is FetchActivitiesError) {
          return Center(child: Text(state.message));
        }
        return Container();
      },
    );
  }

  ListTile _buildListTile(ThemeData theme, Activity activity) {
    var center = LatLng((activity.boundaryNorth + activity.boundarySouth) / 2,
        (activity.boundaryEast + activity.boundaryWest) / 2);
    var bounds = LatLngBounds(
      LatLng(activity.boundarySouth, activity.boundaryWest),
      LatLng(activity.boundaryNorth, activity.boundaryEast),
    );

    var path = activity.records
        .map((e) => LatLng(e.position.latitude, e.position.longitude))
        .toList();
    var modDate = timeago.format(activity.startTime);
    var paddingWidth = 16.0;
    return ListTile(
      onTap: () => Get.to(ShowActivityPage(activity)),
      title: Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: Row(
          children: [
            Expanded(
              child: Text(
                getNameForSport(activity.sportType),
                style: theme.textTheme.headline4,
              ),
            ),
            Tooltip(
              message: activity.startTime.toString(),
              child: Text(modDate, style: theme.textTheme.headline6),
            )
          ],
        ),
      ),
      subtitle: Column(
        children: [
          Container(
            height: 200,
            child: MapTile(center: center, bounds: bounds, path: path),
          ),
          Container(height: 8.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              DataPointDisplay(
                text: (activity.totalDistance / 1000).toStringAsFixed(1),
                iconData: Icons.timeline,
                postfix: ' km',
                tooltip: 'Total Distance Covered',
              ),
              Container(width: paddingWidth),
              DataPointDisplay(
                text: activity.totalAscent.toString(),
                iconData: Icons.arrow_upward,
                postfix: ' m',
                tooltip: 'Total Ascent',
              ),
              Container(width: paddingWidth),
              DataPointDisplay(
                text: activity.totalDescent.toString(),
                iconData: Icons.arrow_downward,
                postfix: ' m',
                tooltip: 'Total Descent',
              ),
              Container(width: paddingWidth),
              DataPointDisplay(
                text: activity.avgHeartRate.toString(),
                iconData: MaterialCommunityIcons.heart,
                postfix: ' bpm',
                tooltip: 'Average Heart Rate',
              ),
              Container(width: paddingWidth),
              DataPointDisplay(
                // 60 * 60 / 1000
                text: (activity.avgSpeed * 3.6).toStringAsFixed(1),
                iconData: MaterialCommunityIcons.speedometer,
                postfix: ' km/h',
                tooltip: 'Speed',
              ),
              Container(width: paddingWidth),
              DataPointDisplay(
                text: (activity.totalTrainingEffect).toStringAsFixed(1),
                iconData: MaterialCommunityIcons.run_fast,
                tooltip: 'Effect',
              ),
            ],
          ),
        ],
      ),
      leading: getIconForSport(activity.sportType),
    );
  }

  void _onScroll() {
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    if (maxScroll - currentScroll <= _scrollThreshold) {
      _bloc.add(FetchActivities());
    }
  }
}
