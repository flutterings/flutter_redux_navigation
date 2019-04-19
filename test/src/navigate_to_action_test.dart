import 'package:flutter_redux_navigation/flutter_redux_navigation.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('should pass the NavigationType.shouldPop and no route name', () {
    var action = NavigateToAction.pop();
    expect(action.type, NavigationType.shouldPop);
    expect(action.name, isNull);
  });

  test('should pass the NavigationType.shouldReplace and route name', () {
    var action = NavigateToAction.replace('name');
    expect(action.type, NavigationType.shouldReplace);
    expect(action.name, 'name');
  });

  test('should pass the NavigationType.shouldPush and route name', () {
    var action = NavigateToAction.push('name');
    expect(action.type, NavigationType.shouldPush);
    expect(action.name, 'name');
  });

  test('should have a default type of NavigationType.shouldPush', () {
    var action = NavigateToAction('name');
    expect(action.type, NavigationType.shouldPush);
  });

  test(
    'should throw AssertionError if the route name is null or empty on NavigationType.shouldPush',
      () {
      expect(() => NavigateToAction(null), throwsAssertionError);
      expect(() => NavigateToAction(''), throwsAssertionError);
    });

  test(
    'should throw AssertionError if the route name is null or empty on NavigationType.shouldReplace',
      () {
      expect(() => NavigateToAction(null, type: NavigationType.shouldReplace),
        throwsAssertionError);
      expect(() => NavigateToAction('', type: NavigationType.shouldReplace),
        throwsAssertionError);
    });

  test('should allow null or empty route name on NavigationType.shouldPop', () {
    expect(() => NavigateToAction(null, type: NavigationType.shouldPop),
      isNotNull);
    expect(
        () => NavigateToAction('', type: NavigationType.shouldPop), isNotNull);
  });

  test(
    'should throw AssertionError if the route name is null or empty or predicate is null on NavigationType.pushNamedAndRemoveUntil',
      () {
      expect(() =>
        NavigateToAction(
          null, type: NavigationType.shouldPushNamedAndRemoveUntil),
        throwsAssertionError);
      expect(() =>
        NavigateToAction(
          '', type: NavigationType.shouldPushNamedAndRemoveUntil),
        throwsAssertionError);
      expect(() =>
        NavigateToAction(
          'name', type: NavigationType.shouldPushNamedAndRemoveUntil),
        throwsAssertionError);
    });
}
