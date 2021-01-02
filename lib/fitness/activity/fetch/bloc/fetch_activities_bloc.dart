import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:get/get.dart';
import 'package:graphql/client.dart';

import '../../activity_repository.dart';
import '../../models/models.dart';

part 'fetch_activities_event.dart';
part 'fetch_activities_state.dart';

class FetchActivitiesBloc
    extends Bloc<FetchActivitiesBaseEvent, FetchActivitiesBaseState> {
  FetchActivitiesBloc() : super(FetchActivitiesInitial());

  @override
  Stream<FetchActivitiesBaseState> mapEventToState(
    FetchActivitiesBaseEvent event,
  ) async* {
    final currentState = state;
    if (event is FetchActivities && !_hasReachedMax(currentState)) {
      try {
        var repo = Get.find<ActivityRepository>();
        if (currentState is FetchActivitiesInitial) {
          try {
            var activities = await repo.getActivities(limit: event.limit);
            yield FetchActivitiesFinishedState(activities, false);
            return;
          } catch (e) {
            if (e is OperationException && e.clientException != null) {
              yield FetchActivitiesError(
                currentState,
                e.clientException.toString(),
              );
            } else if (e is OperationException &&
                e.clientException == null &&
                e.graphqlErrors != null &&
                e.graphqlErrors.isNotEmpty) {
              yield FetchActivitiesError(
                currentState,
                'One or more GQL errors: ${e.graphqlErrors.first.message}',
              );
            } else {
              yield FetchActivitiesError(
                currentState,
                'Unknown error: ${e.message}',
              );
            }
          }
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
