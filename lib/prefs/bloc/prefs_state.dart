part of 'prefs_bloc.dart';

abstract class PrefsBaseState extends Equatable {
  const PrefsBaseState();

  @override
  List<Object> get props => [];
}

class PrefsInitialState extends PrefsBaseState {}

class PrefsLoadingState extends PrefsBaseState {}

class PrefsLoadedState extends PrefsBaseState {
  final Map<String, dynamic> prefs;

  PrefsLoadedState(this.prefs)
      : assert(prefs != null),
        assert(prefs.isNotEmpty);

  @override
  List<Object> get props => prefs.values;
}
