import 'package:fab_circular_menu/fab_circular_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';

import 'auth/blocs/auth/auth_bloc.dart';
import 'fitness/activity/import/import_fit_file_page.dart';
import 'widgets/nav_rail.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  final GlobalKey<FabCircularMenuState> fabKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return NavRail(
      drawerHeaderBuilder: (context) {
        return Column(
          children: <Widget>[
            BlocBuilder<AuthBloc, AuthBaseState>(
              bloc: GetIt.I.get<AuthBloc>(),
              builder: (context, state) {
                if (state is AuthAuthenticated) {
                  return UserAccountsDrawerHeader(
                    accountName: Text(state.user.username),
                    accountEmail: Text(state.user.email),
                  );
                }
                return UserAccountsDrawerHeader(
                  accountName: Text('loading'),
                  accountEmail: Text('loading'),
                );
              },
            )
          ],
        );
      },
      drawerFooterBuilder: (context) {
        return Column(
          children: <Widget>[
            ListTile(
              leading: Icon(Icons.settings),
              title: Text("Settings"),
            ),
            ListTile(
              leading: Icon(Icons.info_outline),
              title: Text("About"),
            ),
          ],
        );
      },
      currentIndex: _currentIndex,
      onTap: (val) {
        if (mounted)
          setState(() {
            _currentIndex = val;
          });
      },
      title: Text('Title'),
      body: IndexedStack(
        index: _currentIndex,
        children: <Widget>[
          Container(color: Colors.blue[300]),
          Container(color: Colors.red[300]),
          Container(color: Colors.purple[300]),
          Container(color: Colors.grey[300]),
        ],
      ),
      floatingActionButton: _buildFabCircularMenu(theme),
      tabs: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          title: Text("Stats"),
          icon: Icon(MaterialCommunityIcons.chart_areaspline),
        ),
        BottomNavigationBarItem(
          title: Text("Activities"),
          icon: Icon(Icons.flag),
        ),
        BottomNavigationBarItem(
          title: Text("Health"),
          icon: Icon(MaterialCommunityIcons.heart),
        ),
      ],
    );
  }

  FabCircularMenu _buildFabCircularMenu(ThemeData theme) {
    return FabCircularMenu(
      key: fabKey,
      animationDuration: Duration(milliseconds: 50),
      ringWidth: 60.0,
      ringColor: theme.backgroundColor,
      ringDiameter: 250.0,
      children: <Widget>[
        _buildIconButtonWithText(
          () {
            _hideMenu();
          },
          'Manual',
          'Manual',
        ),
        _buildIconButtonWithText(
          () {
            Get.to(ImportFitFile());
            _hideMenu();
          },
          'Import',
          'Import via a FIT file',
        ),
      ],
    );
  }

  Widget _buildIconButtonWithText(
    Function onPressed,
    String text,
    String tooltip,
  ) {
    return Container(
      width: 68,
      height: 55,
      child: Stack(
        children: [
          Align(
            alignment: Alignment.bottomCenter,
            child: Text(text),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: IconButton(
              icon: Icon(Icons.edit),
              onPressed: onPressed,
              tooltip: tooltip,
            ),
          ),
        ],
      ),
    );
  }

  void _hideMenu() {
    if (fabKey.currentState.isOpen) {
      fabKey.currentState.close();
    }
  }
}
