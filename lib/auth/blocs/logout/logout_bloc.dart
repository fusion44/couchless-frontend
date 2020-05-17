import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'logout_event.dart';
part 'logout_state.dart';

class LogoutBloc extends Bloc<LogoutBaseEvent, LogoutBaseState> {
  @override
  LogoutBaseState get initialState => LogoutInitial();

  @override
  Stream<LogoutBaseState> mapEventToState(
    LogoutBaseEvent event,
  ) async* {
    // TODO: Add Logic
  }
}
