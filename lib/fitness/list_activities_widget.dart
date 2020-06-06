import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:latlong/latlong.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../common/sport_utils.dart';
import '../common/widgets/map_tile.dart';
import 'activity/fetch/bloc/fetch_activities_bloc.dart';
import 'activity/models/models.dart';

class ListActivitiesWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return BlocBuilder<FetchActivitiesBloc, FetchActivitiesBaseState>(
      bloc: BlocProvider.of<FetchActivitiesBloc>(context),
      builder: (context, state) {
        if (state is FetchActivitiesFinishedState) {
          final activities = state.activities;
          return ListView.separated(
            itemCount: activities.length,
            itemBuilder: (context, i) => _buildListTile(theme, activities[i]),
            separatorBuilder: (context, i) => Divider(),
          );
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

    return ListTile(
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
            height: 250,
            child: MapTile(center: center, bounds: bounds, path: path),
          ),
        ],
      ),
      leading: getIconForSport(activity.sportType),
    );
  }
}
