import 'package:flutter/widgets.dart';
import 'package:redux/redux.dart';

class NavigatorHolder {
  static final navigatorKey = GlobalKey<NavigatorState>();
}

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
