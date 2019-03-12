import 'package:flutter/widgets.dart';
import 'package:redux/redux.dart';

/// Provides a way to keep a reference of the [NavigatorState] globally.
/// It also keeps a global reference of the [NavigationState].
class NavigatorHolder {
  static final navigatorKey = GlobalKey<NavigatorState>();
  static NavigationState state;
}

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

/// The action to be dispatched in the store in order to trigger a navigation.
class NavigateToAction {
  final String name;

  /// If true the [Navigator.pushReplacementNamed] will be called with the
  /// specified [name].
  final bool shouldReplace;

  /// If true the [Navigator.pop] will be called.
  final bool shouldPop;

  /// Optional callback function to be called before the actual navigation.
  /// e.g. activate the loader.
  final Function preNavigation;

  /// Optional callback function to be called after the actual navigation.
  /// e.g. de-activate the loader.
  final Function postNavigation;

  /// Create a navigation action.
  ///
  /// The [name], [shouldReplace] and [shouldPop] parameters must not be null
  /// and only one of them can be true.
  /// The [preNavigation] and [postNavigation] parameters are optional.
  NavigateToAction(this.name, this.shouldReplace, this.shouldPop,
      this.preNavigation, this.postNavigation)
      : assert(shouldReplace != null),
        assert(shouldPop != null),
        assert(!(shouldPop && shouldReplace));

  factory NavigateToAction.push(String name,
          {Function preNavigation, Function postNavigation}) =>
      NavigateToAction(name, false, false, preNavigation, postNavigation);

  factory NavigateToAction.pop(
          {Function preNavigation, Function postNavigation}) =>
      NavigateToAction(null, false, true, preNavigation, postNavigation);

  factory NavigateToAction.replace(String name,
          {Function preNavigation, Function postNavigation}) =>
      NavigateToAction(name, true, false, preNavigation, postNavigation);
}

/// It keeps the current and previous path of the navigation.
class NavigationState {
  final String previousPath;
  final String currentPath;

  NavigationState(this.previousPath, this.currentPath);

  factory NavigationState.initial() => NavigationState(null, null);

  factory NavigationState.transition(String previousPath, String currentPath) =>
      NavigationState(previousPath, currentPath);
}
