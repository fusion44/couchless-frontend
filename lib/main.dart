import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:graphql/client.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'auth/blocs/auth/auth_bloc.dart';
import 'auth/loading_indicator.dart';
import 'auth/login_page.dart';
import 'auth/splash_page.dart';
import 'auth/user_repository.dart';
import 'constants.dart';
import 'fitness/activity/activity_repository.dart';
import 'four_o_four_page.dart';
import 'home_page.dart';
import 'prefs/bloc/prefs_repository.dart';

void main() async {
  await Hive.initFlutter();

  final userRepository = await UserRepository.openRepository();
  // await userRepository.deleteUserData();
  final prefsRepository = await PrefsRepository.openRepository();
  final authBloc = AuthBloc(userRepository)..add(AppStarted());

  Get.put(userRepository);
  Get.put(prefsRepository);
  Get.put(authBloc);

  runApp(App());
}

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  bool graphQLClientReady = false;
  @override
  void initState() {
    if (Get.find<AuthBloc>().state is AuthAuthenticated) {
      // Already authenticated
      _buildGQLClient();
    } else {
      // Listen for authenticated event
      Get.find<AuthBloc>().listen((state) async {
        if (state is AuthAuthenticated) _buildGQLClient();
      });
    }
    super.initState();
  }

  void _buildGQLClient() async {
    // build GraphQL client
    var box = await Hive.openBox('tokens');
    var uri = box.get(prefKeyUrl).toString();
    var jwtToken = box.get(prefKeyJWTToken).toString();
    box.close();

    final httpLink = HttpLink(uri: uri);
    final AuthLink authLink = AuthLink(
      getToken: () => 'Bearer $jwtToken',
    );
    final client = GraphQLClient(
      cache: OptimisticCache(
        dataIdFromObject: typenameDataIdFromObject,
      ),
      link: authLink.concat(httpLink),
    );

    Get.put(client);
    Get.put(ActivityRepository(client));

    setState(() {
      graphQLClientReady = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: ThemeData.dark(),
      home: BlocBuilder<AuthBloc, AuthBaseState>(
        cubit: Get.find<AuthBloc>(),
        builder: (context, state) {
          if (state is AuthUninitialized && !graphQLClientReady) {
            return SplashPage();
          } else if (state is AuthAuthenticated && graphQLClientReady) {
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
