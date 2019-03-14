[![Build Status](https://travis-ci.org/flutterings/flutter_redux_navigation.svg?branch=master)](https://travis-ci.org/flutterings/flutter_redux_navigation)
[![codecov](https://codecov.io/gh/flutterings/flutter_redux_navigation/branch/master/graph/badge.svg)](https://codecov.io/gh/flutterings/flutter_redux_navigation)

# Flutter Navigation for redux

Navigation Middleware for Flutter's redux library.

Basic classes that enables page navigation through by utilizing [Redux](https://pub.dartlang.org/packages/redux) Store middleware facility.

This package is built to work with [Redux.dart](https://pub.dartlang.org/packages/redux) 3.0.0+.

## Redux Middleware

  * `NavigationMiddleware<T>` - The Middleware that reacts to `NavigateToAction`s.

## Examples

Take a look in the [examples](example) directory.

## How to setup navigation

```dart
import 'package:flutter/material.dart';
import 'package:redux/redux.dart';

class AppState {
  final String name;
  
  const AppState(this.name);
  
  factory AppState.initial() => AppState(null);
  factory AppState.changeName(String name) => AppState(name);
}

class AppNameChangedAction {
  final String name;

  AppNameChangedAction(this.name);
}

AppState _onAppNameChanged(AppState state, AppNameChangedAction action) =>
    state.changeName(action.name);

final appReducer = combineReducers<AppState>([
  TypedReducer<AppState, AppNameChangedAction>(_onAppNameChanged),
]);


final store = new Store<AppState>(combineReducers<AppState>([appReducer]),
    initialState: AppState.initial(),
    middleware: [
      NavigationMiddleware<AppState>(),
    ]);

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreProvider<AppState>(
        store: store,
        child: MaterialApp(
          title: 'My App',
          navigatorKey: NavigatorHolder.navigatorKey,
        )
    );
  }
}

void main() => runApp(MyApp());
```

## How to navigate

Let's say you wish to navigate from a `LoginPage` to some dashboard page, you only need to dispatch a `NavigateToAction.replace` action with the appropriate path, which is registered to the dashboard page.

```dart
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AuthBloc>(
      converter: (store) {
        return store;
      },
      builder: (BuildContext context, Store<AppState> store) {
        return Scaffold(body: Builder(
          builder: (BuildContext context) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                RaisedButton(
                onPressed: () {
                  store.dispatch(NavigateToAction.replace('/dashboard'));
                },
                child: Text('Login'),
              )
              ],
            );
          },
        ));
      },
    );
  }
}
```

## How to use pre and post navigation hooks

Let's use the same example as before, but now let's assume that you want to start a loader whilst navigating to the dashboard and stop it once you have navigated. 

```dart
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AuthBloc>(
      converter: (store) {
        return store;
      },
      builder: (BuildContext context, Store<AppState> store) {
        return Scaffold(body: Builder(
          builder: (BuildContext context) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                RaisedButton(
                onPressed: () {
                  store.dispatch(
                    NavigateToAction.replace(
                      '/dashboard',
                      preNavigation: () => store.dispatch(StartLoadingAction()),
                      postNavigation: () => store.dispatch(StopLoadingAction()),
                    ),
                  );
                },
                child: Text('Login'),
              )
              ],
            );
          },
        ));
      },
    );
  }
}