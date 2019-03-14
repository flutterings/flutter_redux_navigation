import 'package:flutter_redux_navigation/flutter_redux_navigation.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('should not allow both shouldReplace and shouldPop to be true', () {
    expect(() => NavigateToAction('name', true, true, null, null),
        throwsAssertionError);
  });

  test('should allow both shouldReplace and shouldPop to be false', () {
    expect(NavigateToAction('name', false, false, null, null), isNotNull);
  });

  test('should not allow only shouldReplace or shouldPop to be true', () {
    expect(NavigateToAction('name', true, false, null, null), isNotNull);
    expect(NavigateToAction('name', false, true, null, null), isNotNull);
  });
}
