import 'package:flutter/widgets.dart';

/// Controls the type of navigation method.
enum NavigationType {
  /// The [Navigator.pushReplacementNamed] will be called.
  shouldReplace,

  /// The [Navigator.pop] will be called.
  shouldPop,

  /// The [Navigator.pushNamed] will be called.
  shouldPush,

  /// The [Navigator.pushNamedAndRemoveUntil] will be called.
  shouldPushNamedAndRemoveUntil,
}

/// The action to be dispatched in the store in order to trigger a navigation.
class NavigateToAction {
  final String name;

  /// Controls the method to be called on the [Navigator] with the specified
  /// [name].
  final NavigationType type;

  /// Optional callback function to be called before the actual navigation.
  /// e.g. activate the loader.
  final Function preNavigation;

  /// Optional callback function to be called after the actual navigation.
  /// e.g. de-activate the loader.
  final Function postNavigation;

  /// Optional object to be passed either in [NavigationType.shouldPush] or
  /// [NavigationType.shouldReplace].
  ///
  /// It will be ignored if passed with type [NavigationType.shouldPop]
  final Object arguments;

  /// Optional object to be passed either in [NavigationType.shouldPushNamedAndRemoveUntil]
  ///
  /// It will be ignored if passed with any other type.
  final RoutePredicate predicate;

  /// Create a navigation action.
  ///
  /// The [name] parameter must not be null.
  /// The [preNavigation] and [postNavigation] parameters are optional.
  NavigateToAction(this.name,
    {this.type = NavigationType.shouldPush,
      this.preNavigation,
      this.postNavigation,
      this.arguments,
      this.predicate})
    : assert(() {
    if (type == NavigationType.shouldPushNamedAndRemoveUntil) {
      return predicate != null;
    }
    if (type != NavigationType.shouldPop) {
      return name != null && name.isNotEmpty;
    }
    return true;
  }());

  factory NavigateToAction.push(String name,
    {Function preNavigation,
      Function postNavigation,
      Object arguments}) =>
    NavigateToAction(name,
      preNavigation: preNavigation,
      postNavigation: postNavigation,
      arguments: arguments);

  factory NavigateToAction.pop(
    {Function preNavigation, Function postNavigation}) =>
    NavigateToAction(null,
      type: NavigationType.shouldPop,
      preNavigation: preNavigation,
      postNavigation: postNavigation);

  factory NavigateToAction.replace(String name,
    {Function preNavigation,
      Function postNavigation,
      Object arguments}) =>
    NavigateToAction(name,
      type: NavigationType.shouldReplace,
      preNavigation: preNavigation,
      postNavigation: postNavigation,
      arguments: arguments);

  factory NavigateToAction.pushNamedAndRemoveUntil(String name,
    RoutePredicate predicate,
    {Function preNavigation,
      Function postNavigation,
      Object arguments}) =>
    NavigateToAction(name,
      type: NavigationType.shouldPushNamedAndRemoveUntil,
      preNavigation: preNavigation,
      postNavigation: postNavigation,
      predicate: predicate,
      arguments: arguments);
}
