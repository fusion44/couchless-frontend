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
    if (event is FetchActivities) {
      var repo = GetIt.I.get<ActivityRepository>();
      var activities = await repo.getActivities();
      yield FetchActivitiesFinishedState(activities);
    }
  }
}
