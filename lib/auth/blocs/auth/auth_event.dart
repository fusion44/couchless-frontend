part of 'auth_bloc.dart';

abstract class AuthBaseEvent extends Equatable {
  const AuthBaseEvent();

  @override
  List<Object> get props => [];
}

class AppStarted extends AuthBaseEvent {}

class LoggedIn extends AuthBaseEvent {
  final String uri;
  final AuthResult authResult;

  const LoggedIn(this.uri, this.authResult);

  @override
  List<Object> get props => [
        this.authResult.jwtToken,
        this.authResult.error,
        this.authResult.errorMessages,
        this.uri,
      ];
}

class LoggedOut extends AuthBaseEvent {}
