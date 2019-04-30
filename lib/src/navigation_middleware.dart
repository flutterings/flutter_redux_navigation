import 'package:flutter/material.dart';
import 'package:flutter_redux_navigation/src/navigate_to_action.dart';
import 'package:flutter_redux_navigation/src/navigation_holder.dart';
import 'package:flutter_redux_navigation/src/navigation_state.dart';
import 'package:redux/redux.dart';

/// Intercepts all dispatched [NavigateToAction] in the [Store] and performs
/// the navigation on the `currentState` of [NavigatorHolder.navigatorKey].
///
/// It can perform either a `replace`, a `push`, a `pushNamedAndRemoveUntil`
/// or a `pop` navigation action.
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

      switch (navigationAction.type) {
        case NavigationType.shouldReplace:
          currentState.pushReplacementNamed(navigationAction.name,
              arguments: navigationAction.arguments);
          this._setStatePrevious(navigationAction.name);
          break;
        case NavigationType.shouldPop:
          currentState.pop();
          this._setStateCurrent(NavigatorHolder.state?.previousPath);
          break;
        case NavigationType.shouldPushNamedAndRemoveUntil:
          currentState.pushNamedAndRemoveUntil(
            navigationAction.name, navigationAction.predicate,
            arguments: navigationAction.arguments);
          this._setStateCurrent(null);
          break;
        default:
          currentState.pushNamed(navigationAction.name,
              arguments: navigationAction.arguments);
          this._setStateCurrent(navigationAction.name);
      }

      if (action.postNavigation != null) {
        action.postNavigation();
      }
    }

    next(action);
  }

  /// Set new state and keeps currentPath as previousPath.
  /// For POP and PUSH actions.
  void _setStateCurrent(String currentPath) {
    NavigatorHolder.state = NavigationState.transition(
      NavigatorHolder.state?.currentPath, currentPath);
  }

  /// Set new state and keeps previousPath.
  /// For REPLACE action.
  void _setStatePrevious(String currentPath) {
    NavigatorHolder.state = NavigationState.transition(
        NavigatorHolder.state?.previousPath, currentPath);
  }
}
