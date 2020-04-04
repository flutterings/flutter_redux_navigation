import 'package:flutter_redux_navigation/flutter_redux_navigation.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('should have null paths as initial state', () {
    final state = NavigationState.initial();

    expect(state.previousPath, isNull);
    expect(state.currentPath, isNull);
  });

  test('should set previousPath, previousArguments, currentPath, and currentArguments on transition', () {
    final state = NavigationState.transition('previousPath', 'previousArguments', 'currentPath', 'currentArguments');

    expect(state.previousPath, 'previousPath');
    expect(state.previousArguments, 'previousArguments');
    expect(state.currentPath, 'currentPath');
    expect(state.currentArguments, 'currentArguments');
  });

  test(
      'should allow null values for previousPath, previousArguments, currentPath, and currentArguments on transition',
      () {
    final state = NavigationState.transition(null, null, null, null);

    expect(state.previousPath, isNull);
    expect(state.currentPath, isNull);
  });
}
