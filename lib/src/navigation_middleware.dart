import 'package:flutter/material.dart';
import 'package:flutter_redux_navigation/src/navigate_to_action.dart';
import 'package:flutter_redux_navigation/src/navigation_destination.dart';
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
  final NavigatorState? currentState;

  const NavigationMiddleware({this.currentState});

  @override
  void call(Store<T> store, dynamic action, NextDispatcher next) {
    if (action is NavigateToAction) {
      final NavigateToAction navigationAction = action;
      final NavigatorState currentState = (this.currentState ?? NavigatorHolder.navigatorKey.currentState)!;

      action.preNavigation?.call();

      switch (navigationAction.type) {
        case NavigationType.shouldReplace:
          currentState.pushReplacementNamed(
            navigationAction.name!,
            arguments: navigationAction.arguments
          );
          this._setCurrentDestination(NavigationDestination(
            navigationAction.name!,
            navigationAction.arguments
          ));

          break;
        case NavigationType.shouldPop:
          currentState.pop();
          this._setCurrentDestination(NavigatorHolder.state?.previousDestination);

          break;
        case NavigationType.shouldPopUntil:
          currentState.popUntil(navigationAction.predicate!);
          this._setDestination(
            previousDestination: null,
            currentDestination: NavigationDestination(navigationAction.name!, navigationAction.arguments)
          );

          break;
        case NavigationType.shouldPushNamedAndRemoveUntil:
          currentState.pushNamedAndRemoveUntil(
            navigationAction.name!,
            navigationAction.predicate!,
            arguments: navigationAction.arguments
          );
          this._setDestination(
            previousDestination: null,
            currentDestination: NavigationDestination(navigationAction.name!, navigationAction.arguments)
          );

          break;
        default:
          currentState.pushNamed(
            navigationAction.name!,
            arguments: navigationAction.arguments
          );
          this._setCurrentDestination(NavigationDestination(
            navigationAction.name!,
            navigationAction.arguments
          ));
      }

      action.postNavigation?.call();
    }

    next(action);
  }

  void _setCurrentDestination(NavigationDestination? currentDestination) => this._setDestination(
    previousDestination: NavigatorHolder.state?.currentDestination,
    currentDestination: currentDestination
  );

  void _setDestination({ NavigationDestination? previousDestination, NavigationDestination? currentDestination }) =>
    NavigatorHolder.state = NavigationState.transition(
        previousDestination,
        currentDestination
    );
}
