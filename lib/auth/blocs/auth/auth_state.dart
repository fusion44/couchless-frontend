part of 'auth_bloc.dart';

abstract class AuthBaseState extends Equatable {
  const AuthBaseState();

  @override
  List<Object> get props => [];
}

class AuthUninitialized extends AuthBaseState {}

class AuthAuthenticated extends AuthBaseState {}

class AuthUnauthenticated extends AuthBaseState {}

class AuthLoading extends AuthBaseState {}
