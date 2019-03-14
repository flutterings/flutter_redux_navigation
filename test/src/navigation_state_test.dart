import 'package:flutter_redux_navigation/flutter_redux_navigation.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('should have null paths as initial state', () {
    final state = NavigationState.initial();

    expect(state.previousPath, isNull);
    expect(state.currentPath, isNull);
  });

  test('should set previousPath and currentPath on transition', () {
    final state = NavigationState.transition('previousPath', 'currentPath');

    expect(state.previousPath, 'previousPath');
    expect(state.currentPath, 'currentPath');
  });

  test(
      'should allow null values for previousPath and currentPath on transition',
      () {
    final state = NavigationState.transition(null, null);

    expect(state.previousPath, isNull);
    expect(state.currentPath, isNull);
  });
}
