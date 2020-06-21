import 'dart:async';

import 'package:graphql/client.dart';

import 'models/models.dart';

class ActivityRepository {
  final GraphQLClient _gqlClient;
  Map<String, Activity> _activityCache = {};

  ActivityRepository(this._gqlClient) : assert(_gqlClient != null);

  FutureOr<List<Activity>> getActivities({
    int limit = 10,
    int offset = 0,
  }) async {
    var activities = <Activity>[];
    var res = await _gqlClient.query(_getOptions(limit, offset));
    if (res.hasException) {
      return activities;
    }
    for (var a in res.data['activities']) {
      activities.add(Activity.fromJson(a));
    }
    return activities;
  }

  Future<Activity> getActivity(String id) async {
    return null;
  }

  QueryOptions _getOptions(int limit, int offset) {
    return QueryOptions(
      documentNode: gql('''
query GetActivities {
  activities(limit: $limit, offset: $offset) {
    id
    comment
    startTime
    endTime
    sportType
    boundaryNorth
    boundarySouth
    boundaryEast
    boundaryWest
    timePaused
    avgPace
    avgSpeed
    avgCadence
    avgFractionalCadence
    maxCadence
    maxSpeed
    totalDistance
    totalAscent
    totalDescent
    maxAltitude
    avgHeartRate
    maxHeartRate
    totalTrainingEffect
    records {
      id
      timestamp
      positionLat
      positionLong
      distance
      heartRate
      altitude
      speed
    }
  }
}
'''),
    );
  }
}
