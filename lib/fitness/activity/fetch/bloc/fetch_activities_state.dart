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
  final bool hasReachedMax;

  FetchActivitiesFinishedState(this.activities, this.hasReachedMax);

  FetchActivitiesFinishedState copyWith({
    List<Activity> activities,
    bool hasReachedMax,
  }) {
    return FetchActivitiesFinishedState(
      activities ?? this.activities,
      hasReachedMax ?? this.hasReachedMax,
    );
  }

  @override
  List<Object> get props => [...activities, hasReachedMax];

  @override
  String toString() =>
      'FetchActivitiesFinishedState { activities: ${activities.length}, hasReachedMax: $hasReachedMax }';
}

class FetchActivitiesError extends FetchActivitiesBaseState {
  final FetchActivitiesBaseState lastState;
  final String message;

  FetchActivitiesError(this.lastState, this.message);

  @override
  List<Object> get props => [lastState, message];
}
