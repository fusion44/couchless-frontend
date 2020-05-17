part of 'prefs_bloc.dart';

abstract class PrefsBaseEvent extends Equatable {
  const PrefsBaseEvent();

  @override
  List<Object> get props => [];
}

class LoadAllPrefsEvent extends PrefsBaseEvent {}

class LoadPrefsEvent extends PrefsBaseEvent {
  final List<String> prefs;

  LoadPrefsEvent(this.prefs)
      : assert(prefs != null),
        assert(prefs.isNotEmpty);

  @override
  List<Object> get props => prefs;
}

class SavePrefsEvent extends PrefsBaseEvent {
  final Map<String, dynamic> prefs;

  SavePrefsEvent(this.prefs)
      : assert(prefs != null),
        assert(prefs.isNotEmpty);

  @override
  List<Object> get props => prefs.values;
}
