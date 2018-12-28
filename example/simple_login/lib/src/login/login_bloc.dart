import 'package:flutter_redux_navigation/flutter_redux_navigation.dart';
import 'package:redux/redux.dart';
import 'package:simple_login/src/app_store.dart';

class LoginBloc {
  final Store<AppState> _store;

  LoginBloc(this._store);

  void login() {
    this._store.dispatch(NavigateToAction.replace("/dashboard"));
  }
}