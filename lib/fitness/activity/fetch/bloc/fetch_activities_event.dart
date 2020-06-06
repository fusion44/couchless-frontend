part of 'fetch_activities_bloc.dart';

abstract class FetchActivitiesBaseEvent extends Equatable {
  const FetchActivitiesBaseEvent();
}

class FetchActivities extends FetchActivitiesBaseEvent {
  final int offset;
  final int limit;

  FetchActivities([this.offset = 0, this.limit = 10]);

  @override
  List<Object> get props => [offset, limit];
}
