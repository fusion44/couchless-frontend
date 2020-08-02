import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:get/get.dart';

import 'prefs_repository.dart';

part 'prefs_event.dart';
part 'prefs_state.dart';

class PrefsBloc extends Bloc<PrefsBaseEvent, PrefsBaseState> {
  PrefsBloc() : super(PrefsInitialState());

  @override
  Stream<PrefsBaseState> mapEventToState(
    PrefsBaseEvent event,
  ) async* {
    final prefsRepository = Get.find<PrefsRepository>();

    if (event is LoadAllPrefsEvent) {
      var prefs = await prefsRepository.loadAll();
      yield PrefsLoadedState(prefs);
    } else if (event is LoadPrefsEvent) {
      var prefs = await prefsRepository.load(event.prefs);
      yield PrefsLoadedState(prefs);
    } else if (event is SavePrefsEvent) {
      await prefsRepository.saveAll(event.prefs);
    }
  }
}
