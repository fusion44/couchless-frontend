import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../constants.dart';
import '../../prefs/bloc/prefs_bloc.dart';
import '../blocs/login/login_bloc.dart';

class LoginForm extends StatefulWidget {
  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _urlController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  Bloc _prefsBloc;

  @override
  void initState() {
    _prefsBloc = PrefsBloc();
    _prefsBloc.add(LoadPrefsEvent([prefKeyUrl]));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _onLoginButtonPressed() {
      _prefsBloc.add(SavePrefsEvent({prefKeyUrl: _urlController.text}));
      BlocProvider.of<LoginBloc>(context).add(
        LoginButtonPressed(
          uri: _urlController.text,
          username: _usernameController.text,
          password: _passwordController.text,
        ),
      );
    }

    return MultiBlocListener(
      listeners: [
        BlocListener<LoginBloc, LoginBaseState>(
          listener: (context, state) {
            if (state is LoginFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${state.errors}'),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
        ),
        BlocListener<PrefsBloc, PrefsBaseState>(
          cubit: _prefsBloc,
          listener: (context, state) {
            if (state is PrefsLoadedState) {
              if (state.prefs.containsKey(prefKeyUrl) &&
                  state.prefs[prefKeyUrl] != null &&
                  _urlController.text.isEmpty) {
                _urlController.text = state.prefs[prefKeyUrl];
              }
            }
          },
        ),
      ],
      child: BlocBuilder<LoginBloc, LoginBaseState>(
        builder: (context, state) {
          return Form(
            child: Column(
              children: [
                TextFormField(
                  decoration: InputDecoration(labelText: 'Backend URL'),
                  controller: _urlController,
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'username'),
                  controller: _usernameController,
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'password'),
                  controller: _passwordController,
                  obscureText: true,
                ),
                RaisedButton(
                  onPressed:
                      state is! LoginLoading ? _onLoginButtonPressed : null,
                  child: Text('Login'),
                ),
                Container(
                  child: state is LoginLoading
                      ? CircularProgressIndicator()
                      : null,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
