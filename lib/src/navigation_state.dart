import 'package:flutter_redux_navigation/src/navigation_destination.dart';

/// It keeps the current and previous path of the navigation.
class NavigationState {
  final NavigationDestination previousDestination;
  final NavigationDestination currentDestination;

  @Deprecated('Use previousDestination.path instead')
  String get previousPath => previousDestination?.path;

  @Deprecated('Use currentDestination.path instead')
  String get currentPath => currentDestination?.path;

  NavigationState(this.previousDestination, this.currentDestination);

  factory NavigationState.initial() => NavigationState(null, null);

  factory NavigationState.transition(NavigationDestination previousDestination, NavigationDestination currentDestination) =>
      NavigationState(previousDestination, currentDestination);
}
