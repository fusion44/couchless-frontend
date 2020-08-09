import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:get/get.dart';

import '../../models/models.dart';
import '../../stats_repository.dart';

part 'fetch_stats_event.dart';
part 'fetch_stats_state.dart';

class FetchStatsBloc extends Bloc<FetchStatsEvent, FetchStatsState> {
  FetchStatsBloc() : super(FetchStatsInitial());

  @override
  Stream<FetchStatsState> mapEventToState(
    FetchStatsEvent event,
  ) async* {
    var repo = Get.find<StatsRepository>();
    try {
      var stats = await repo.getUserStats();

      var statsSorted = <String, List<UserStat>>{};

      for (var s in stats.reversed) {
        if (!statsSorted.containsKey(s.period.toString())) {
          statsSorted[s.period.toString()] = [];
        }
        statsSorted[s.period].add(s);
      }

      yield FetchStatsFinishedState(statsSorted);
    } catch (e, trace) {
      print(e);
      print(trace);
      yield FetchStatsError({}, e.toString());
    }
  }
}
