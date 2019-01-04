import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_redux_navigation/flutter_redux_navigation.dart';
import 'package:simple_login/src/app_store.dart';
import 'package:simple_login/src/dashboard/dashboard_bloc.dart';

class DashboardPage extends StatefulWidget {
  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, DashboardBloc>(
      converter: (store) {
        return DashboardBloc(store);
      },
      builder: (BuildContext context, DashboardBloc bloc) {
        return Scaffold(
            drawer: Drawer(
              child: ListView(padding: EdgeInsets.zero, children: <Widget>[
                DrawerHeader(
                  child: Text('Simple Login Example'),
                ),
                ListTile(
                  title: Text('Dashboard'),
                  selected: NavigatorHolder.state.currentPath == '/dashboard',
                )
              ]),
            ),
            appBar: AppBar(
              title: Text('Dashboard Page'),
            ),
            body: Builder(
              builder: (BuildContext context) {
                return Container(
                  alignment: Alignment.center,
                  child: RaisedButton(
                    onPressed: bloc.logout,
                    child: Text('Logout'),
                  ),
                );
              },
            ));
      },
    );
    ;
  }
}
