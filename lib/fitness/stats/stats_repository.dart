import 'dart:async';

import 'package:graphql/client.dart';

import 'models/user_stat.dart';

class StatsRepository {
  final GraphQLClient _gqlClient;

  StatsRepository(this._gqlClient) : assert(_gqlClient != null);

  FutureOr<List<UserStat>> getUserStats() async {
    var stats = <UserStat>[];
    var res = await _gqlClient.query(_getOptions());
    if (res.hasException) {
      return stats;
    }
    for (var a in res.data['userStats']) {
      stats.add(UserStat.fromJson(a));
    }
    return stats;
  }

  QueryOptions _getOptions() {
    return QueryOptions(
      documentNode: gql('''
query GetStats {
  userStats {
    period
    total
    sportType
  }
}
'''),
    );
  }
}
