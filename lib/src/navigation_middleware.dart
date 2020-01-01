import 'package:flutter/material.dart';
import 'package:flutter_redux_navigation/src/navigate_to_action.dart';
import 'package:flutter_redux_navigation/src/navigation_holder.dart';
import 'package:flutter_redux_navigation/src/navigation_state.dart';
import 'package:redux/redux.dart';

/// Intercepts all dispatched [NavigateToAction] in the [Store] and performs
/// the navigation on the `currentState` of [NavigatorHolder.navigatorKey].
///
/// It can perform either a `replace`, a `push`, a `pushNamedAndRemoveUntil`
/// a `pop`, or a `popUntil` navigation action.
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
          this._setState(navigationAction.name);
          break;
        case NavigationType.shouldPop:
          currentState.pop();
          this._setState(NavigatorHolder.state?.previousPath);
          break;
        case NavigationType.shouldPopUntil:
          currentState.popUntil(navigationAction.predicate);
          this._setState(null);
          break;
        case NavigationType.shouldPushNamedAndRemoveUntil:
          currentState.pushNamedAndRemoveUntil(
              navigationAction.name, navigationAction.predicate,
              arguments: navigationAction.arguments);
          this._setState(null);
          break;
        default:
          currentState.pushNamed(navigationAction.name,
              arguments: navigationAction.arguments);
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
