import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:lifelog/prefs/bloc/prefs_bloc.dart';
import 'package:meta/meta.dart';

import '../../user_repository.dart';
import '../auth/auth_bloc.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginBaseEvent, LoginBaseState> {
  final UserRepository userRepository;
  final AuthBloc authBloc;
  final PrefsBloc prefsBloc;

  LoginBloc(this.userRepository, this.authBloc, this.prefsBloc)
      : assert(userRepository != null),
        assert(authBloc != null),
        assert(prefsBloc != null);

  @override
  LoginBaseState get initialState => LoginInitial();

  @override
  Stream<LoginBaseState> mapEventToState(
    LoginBaseEvent event,
  ) async* {
    if (event is LoginButtonPressed) {
      yield LoginLoading();

      try {
        final result = await userRepository.authenticate(
          uri: event.uri,
          username: event.username,
          password: event.password,
        );

        if (result.error) {
          yield LoginFailure(errors: result.errorMessages);
        } else {
          authBloc.add(LoggedIn(result));
          yield LoginInitial();
        }
      } catch (error) {
        yield LoginFailure(errors: [error.toString()]);
      }
    }
  }
}
