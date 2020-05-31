import 'dart:async';

import 'package:fit2json/models/activity.dart';
import 'package:graphql/client.dart';

class ActivityRepository {
  final GraphQLClient gqlClient;
  Map<String, Activity> activityCache = {};

  ActivityRepository(this.gqlClient) : assert(gqlClient != null);

  Future<Activity> getActivity(String id) async {
    return null;
  }
}
