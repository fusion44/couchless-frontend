import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:get_it/get_it.dart';

import 'auth/blocs/auth/auth_bloc.dart';
import 'auth/loading_indicator.dart';
import 'auth/login_page.dart';
import 'auth/splash_page.dart';
import 'auth/user_repository.dart';
import 'four_o_four_page.dart';
import 'home_page.dart';
import 'prefs/bloc/prefs_repository.dart';

class SimpleBlocDelegate extends BlocDelegate {
  @override
  void onEvent(Bloc bloc, Object event) {
    super.onEvent(bloc, event);
    print(event);
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    print(transition);
  }

  @override
  void onError(Bloc bloc, Object error, StackTrace stacktrace) {
    super.onError(bloc, error, stacktrace);
    print(error);
  }
}

void main() async {
  BlocSupervisor.delegate = SimpleBlocDelegate();

  await Hive.initFlutter();

  final userRepository = await UserRepository.openRepository();
  // await userRepository.deleteToken();
  final prefsRepository = await PrefsRepository.openRepository();
  final authBloc = AuthBloc(userRepository)..add(AppStarted());

  final getIt = GetIt.instance;

  getIt.registerSingleton<UserRepository>(userRepository);
  getIt.registerSingleton<PrefsRepository>(prefsRepository);
  getIt.registerSingleton<AuthBloc>(authBloc);

  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      home: BlocBuilder<AuthBloc, AuthBaseState>(
        bloc: GetIt.I.get<AuthBloc>(),
        builder: (context, state) {
          print(state);
          if (state is AuthUninitialized) {
            return SplashPage();
          } else if (state is AuthAuthenticated) {
            return HomePage();
          } else if (state is AuthUnauthenticated) {
            return LoginPage();
          } else if (state is AuthLoading) {
            return LoadingIndicator();
          } else {
            return FourOFourPage(errorText: 'Unknown authState $state');
          }
        },
      ),
    );
  }
}
