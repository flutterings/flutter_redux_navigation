import 'package:flutter_redux_navigation/flutter_redux_navigation.dart';
import 'package:redux/redux.dart';
import 'package:simple_login/src/app_store.dart';

class DashboardBloc {
  final Store<AppState> _store;

  DashboardBloc(this._store);

  void logout() {
    this._store.dispatch(NavigateToAction.replace("/login"));
  }
}