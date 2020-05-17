import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:lifelog/auth/models/auth_models.dart';

import '../../user_repository.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthBaseEvent, AuthBaseState> {
  final UserRepository userRepository;

  AuthBloc(this.userRepository) : assert(userRepository != null);

  @override
  AuthBaseState get initialState => AuthUninitialized();

  @override
  Stream<AuthBaseState> mapEventToState(AuthBaseEvent event) async* {
    if (event is AppStarted) {
      bool hasToken = await userRepository.hasToken();
      if (hasToken) {
        yield AuthAuthenticated(await userRepository.getUser());
      } else {
        yield AuthUnauthenticated();
      }
    } else if (event is LoggedIn) {
      yield AuthLoading();
      await userRepository.persistUserData(event.authResult);
      yield AuthAuthenticated(event.authResult.user);
    } else if (event is LoggedOut) {
      yield AuthLoading();
      await userRepository.deleteUserData();
      yield AuthUnauthenticated();
    }
  }
}
