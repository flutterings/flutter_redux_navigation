import 'package:flutter/material.dart';
import 'package:flutter_redux_navigation/flutter_redux_navigation.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:simple_login/src/app_store.dart';
import 'package:simple_login/src/dashboard/dashboard_page.dart';
import 'package:simple_login/src/login/login_page.dart';

class SimpleLoginApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreProvider<AppState>(
      store: store,
      child: MaterialApp(
        title: 'Simple Login Example',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        navigatorKey: NavigatorHolder.navigatorKey,
        onGenerateRoute: _getRoute,
      ),
    );
  }

  Route _getRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/login':
        return _buildRoute(settings, LoginPage());
      case '/dashboard':
        return _buildRoute(settings, DashboardPage());
      default:
        return _buildRoute(settings, LoginPage());
    }
  }

  MaterialPageRoute _buildRoute(RouteSettings settings, Widget builder) {
    return new MaterialPageRoute(
      settings: settings,
      builder: (BuildContext context) => builder,
    );
  }
}
