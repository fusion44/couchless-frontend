import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import 'auth/blocs/auth/auth_bloc.dart';
import 'widgets/nav_rail.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
      tabs: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          title: Text("Stats"),
          icon: Icon(MdiIcons.chartAreaspline),
        ),
        BottomNavigationBarItem(
          title: Text("Activities"),
          icon: Icon(Icons.flag),
        ),
        BottomNavigationBarItem(
          title: Text("Health"),
          icon: Icon(MdiIcons.heart),
        ),
      ],
    );
  }
}

// _getDir();
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) {
//                     return LoginPage();
//                   },
//                 ),
//               );

// void _getDir() async {
//   var dir =
//       Platform.environment['HOME'] ?? Platform.environment['USERPROFILE'];

//   print(dir);
// }
