part of 'fetch_activities_bloc.dart';

abstract class FetchActivitiesBaseEvent extends Equatable {
  const FetchActivitiesBaseEvent();
}

class FetchActivities extends FetchActivitiesBaseEvent {
  final int limit;

  FetchActivities([this.limit = 10]);

  @override
  List<Object> get props => [limit];
}
