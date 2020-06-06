part of 'fetch_activities_bloc.dart';

abstract class FetchActivitiesBaseState extends Equatable {
  const FetchActivitiesBaseState();
}

class FetchActivitiesInitial extends FetchActivitiesBaseState {
  @override
  List<Object> get props => [];
}

class FetchActivitiesFinishedState extends FetchActivitiesBaseState {
  final List<Activity> activities;

  FetchActivitiesFinishedState(this.activities);

  @override
  List<Object> get props => activities;
}
