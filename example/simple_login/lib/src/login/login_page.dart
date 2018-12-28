import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:simple_login/src/app_store.dart';
import 'package:simple_login/src/login/login_bloc.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, LoginBloc>(
      converter: (store) {
        return LoginBloc(store);
      },
      builder: (BuildContext context, LoginBloc bloc) {
        return Scaffold(
            appBar: AppBar(
              title: Text('Login Page'),
            ),
            body: Builder(
              builder: (BuildContext context) {
                return Container(
                  alignment: Alignment.center,
                  child: RaisedButton(
                    onPressed: bloc.login,
                    child: Text('Login'),
                  ),
                );
              },
            ));
      },
    );
  }
}
