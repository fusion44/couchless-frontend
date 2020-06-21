import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

import '../prefs/bloc/prefs_bloc.dart';
import 'blocs/auth/auth_bloc.dart';
import 'blocs/login/login_bloc.dart';
import 'user_repository.dart';
import 'widgets/login_form.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: BlocProvider(
        create: (context) {
          return LoginBloc(
            Get.find<UserRepository>(),
            Get.find<AuthBloc>(),
            PrefsBloc(),
          );
        },
        child: LoginForm(),
      ),
    );
  }
}
