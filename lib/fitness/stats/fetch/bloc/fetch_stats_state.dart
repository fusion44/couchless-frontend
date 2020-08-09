part of 'fetch_stats_bloc.dart';

abstract class FetchStatsState extends Equatable {
  const FetchStatsState();
}

class FetchStatsInitial extends FetchStatsState {
  @override
  List<Object> get props => [];
}

class FetchStatsFinishedState extends FetchStatsState {
  final Map<String, List<UserStat>> stats;

  FetchStatsFinishedState(this.stats);

  @override
  List<Object> get props => stats.keys.toList();
}

class FetchStatsError extends FetchStatsState {
  final Map<String, List<UserStat>> stats;
  final String message;

  FetchStatsError(this.stats, this.message);

  @override
  List<Object> get props => [...stats.values, message];
}
