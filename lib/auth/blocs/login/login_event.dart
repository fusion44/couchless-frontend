part of 'login_bloc.dart';

abstract class LoginBaseEvent extends Equatable {
  const LoginBaseEvent();
}

class LoginButtonPressed extends LoginBaseEvent {
  final String uri;
  final String username;
  final String password;

  const LoginButtonPressed({
    @required this.uri,
    @required this.username,
    @required this.password,
  });

  @override
  List<Object> get props => [uri, username, password];
}
