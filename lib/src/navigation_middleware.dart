import 'package:flutter/material.dart';
import 'package:flutter_redux_navigation/src/navigate_to_action.dart';
import 'package:flutter_redux_navigation/src/navigation_holder.dart';
import 'package:flutter_redux_navigation/src/navigation_state.dart';
import 'package:redux/redux.dart';

/// Intercepts all dispatched [NavigateToAction] in the [Store] and performs
/// the navigation on the `currentState` of [NavigatorHolder.navigatorKey].
///
/// It can perform either a `replace`, a `push` or a `pop` navigation action.
/// Prerequisite is to have register the appropriate navigation paths in
/// `onGenerateRoute` method passed to [MaterialApp].
class NavigationMiddleware<T> implements MiddlewareClass<T> {
  final NavigatorState currentState;

  NavigationMiddleware({this.currentState});

  @override
  void call(Store<T> store, dynamic action, NextDispatcher next) {
    if (action is NavigateToAction) {
      final navigationAction = action;
      final currentState =
          this.currentState ?? NavigatorHolder.navigatorKey.currentState;

      if (action.preNavigation != null) {
        action.preNavigation();
      }

      if (navigationAction.shouldReplace) {
        currentState.pushReplacementNamed(navigationAction.name);
        this._setState(navigationAction.name);
      } else if (navigationAction.shouldPop) {
        currentState.pop();
        this._setState(NavigatorHolder.state?.previousPath);
      } else {
        currentState.pushNamed(navigationAction.name);
        this._setState(navigationAction.name);
      }

      if (action.postNavigation != null) {
        action.postNavigation();
      }
    }

    next(action);
  }

  void _setState(String currentPath) {
    NavigatorHolder.state = NavigationState.transition(
        NavigatorHolder.state?.currentPath, currentPath);
  }
}
