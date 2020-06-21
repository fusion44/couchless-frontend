import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:get_it/get_it.dart';

import '../../activity_repository.dart';
import '../../models/models.dart';

part 'fetch_activities_event.dart';
part 'fetch_activities_state.dart';

class FetchActivitiesBloc
    extends Bloc<FetchActivitiesBaseEvent, FetchActivitiesBaseState> {
  @override
  FetchActivitiesBaseState get initialState => FetchActivitiesInitial();

  @override
  Stream<FetchActivitiesBaseState> mapEventToState(
    FetchActivitiesBaseEvent event,
  ) async* {
    final currentState = state;
    if (event is FetchActivities && !_hasReachedMax(currentState)) {
      try {
        var repo = GetIt.I.get<ActivityRepository>();
        if (currentState is FetchActivitiesInitial) {
          var activities = await repo.getActivities(limit: event.limit);
          yield FetchActivitiesFinishedState(activities, false);
          return;
        }
        if (currentState is FetchActivitiesFinishedState) {
          var activities = await repo.getActivities(
            limit: event.limit,
            offset: currentState.activities.length,
          );

          yield activities.isEmpty
              ? currentState.copyWith(hasReachedMax: true)
              : FetchActivitiesFinishedState(
                  currentState.activities + activities,
                  false,
                );
        }
      } catch (e, trace) {
        print(trace);
        yield FetchActivitiesError(state, e.toString());
      }
    }
  }

  bool _hasReachedMax(FetchActivitiesBaseState state) =>
      state is FetchActivitiesFinishedState && state.hasReachedMax;
}
