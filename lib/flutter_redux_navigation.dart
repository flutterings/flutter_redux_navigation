import 'package:flutter/widgets.dart';
import 'package:redux/redux.dart';

/// Provides a way to keep a reference of the `NavigatorState` globally.
class NavigatorHolder {
  static final navigatorKey = GlobalKey<NavigatorState>();
}

/// Intercepts all dispatched [NavigateToAction] in the [Store] and performs
/// the navigation on the `currentState` of [NavigatorHolder.navigatorKey].
///
/// It can perform either a `replace`, a `push` or a `pop` navigation action.
/// Prerequisite is to have register the appropriate navigation paths in
/// `onGenerateRoute` method passed to [MaterialApp].
class NavigationMiddleware<T> implements MiddlewareClass<T> {
  @override
  void call(Store<T> store, dynamic action, NextDispatcher next) {
    if (action is NavigateToAction) {
      final navigationAction = action;
      final currentState = NavigatorHolder.navigatorKey.currentState;

      if (navigationAction.shouldReplace) {
        currentState.pushReplacementNamed(navigationAction.name);
      } else if (navigationAction.shouldPop) {
        currentState.pop();
      } else {
        currentState.pushNamed(navigationAction.name);
      }
    }

    next(action);
  }
}

/// The action to be dispatched in the store in order to trigger a navigation.
class NavigateToAction {
  final String name;
  final bool shouldReplace;
  final bool shouldPop;

  NavigateToAction(this.name, this.shouldReplace, this.shouldPop);

  factory NavigateToAction.push(String name) =>
      NavigateToAction(name, false, false);

  factory NavigateToAction.pop() => NavigateToAction(null, false, true);

  factory NavigateToAction.replace(String name) =>
      NavigateToAction(name, true, false);
}
