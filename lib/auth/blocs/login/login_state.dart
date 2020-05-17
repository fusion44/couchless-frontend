part of 'login_bloc.dart';

abstract class LoginBaseState extends Equatable {
  const LoginBaseState();

  @override
  List<Object> get props => [];
}

class LoginInitial extends LoginBaseState {}

class LoginLoading extends LoginBaseState {}

class LoginFailure extends LoginBaseState {
  final List<String> errors;

  const LoginFailure({@required this.errors});

  @override
  List<Object> get props => errors;

  @override
  String toString() => 'LoginFailure { errors: $errors }';
}
