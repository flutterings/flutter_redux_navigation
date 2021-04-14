import 'package:flutter_redux_navigation/flutter_redux_navigation.dart';
import 'package:flutter_redux_navigation/src/navigation_destination.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('should have null destinations as initial state', () {
    final state = NavigationState.initial();

    expect(state.previousPath, isNull);
    expect(state.currentPath, isNull);

    expect(state.previousDestination, isNull);
    expect(state.currentDestination, isNull);
  });

  test('should set previousDestination and currentDestination on transition', () {
    final state = NavigationState.transition(
      NavigationDestination('previousPath', 'previousArguments'),
      NavigationDestination('currentPath', 'currentArguments'),
    );

    expect(state.previousPath, 'previousPath');
    expect(state.currentPath, 'currentPath');

    expect(state.previousDestination!.path, 'previousPath');
    expect(state.previousDestination!.arguments, 'previousArguments');
    expect(state.currentDestination!.path, 'currentPath');
    expect(state.currentDestination!.arguments, 'currentArguments');
  });

  test(
      'should allow null values for previousDestination, and currentDestination on transition',
      () {
    final state = NavigationState.transition(null, null);

    expect(state.previousPath, isNull);
    expect(state.currentPath, isNull);

    expect(state.previousDestination, isNull);
    expect(state.currentDestination, isNull);
  });
}
