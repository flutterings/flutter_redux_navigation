import 'package:flutter/material.dart';
import 'package:flutter_redux_navigation/flutter_redux_navigation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:redux/redux.dart';

class TestState {}

class NoopAction {}

class MockStore extends Mock implements Store<TestState> {}

class MockNavigatorState extends Mock implements NavigatorState {
  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.debug}) {
    return super.toString();
  }
}

void main() {
  setUp(() {
    MaterialApp(
      navigatorKey: NavigatorHolder.navigatorKey,
    );
    NavigatorHolder.state = null;
  });

  test('should not handle other than NavigateToActions', () {
    final store = MockStore();
    final log = [];

    NavigationMiddleware().call(store, NoopAction(), (_) => log.add('next'));

    expect(log, ['next']);
  });

  group('currentState', () {
    test('should call pushNamed on currentState', () {
      final store = MockStore();
      final navigatorState = MockNavigatorState();

      NavigationMiddleware(currentState: navigatorState)
          .call(store, NavigateToAction.push('/name'), (_) {});

      verifyNever(navigatorState.pushReplacementNamed(any));
      verifyNever(navigatorState.pop());
      verifyNever(navigatorState.popUntil(any));
      verifyNever(navigatorState.pushNamedAndRemoveUntil(any, any));
      verify(navigatorState.pushNamed('/name'));
    });

    test('should call pushNamed on currentState with arguments', () {
      final store = MockStore();
      final navigatorState = MockNavigatorState();
      final arguments = {};

      NavigationMiddleware(currentState: navigatorState).call(
          store, NavigateToAction.push('/name', arguments: arguments), (_) {});

      verifyNever(navigatorState.pushReplacementNamed(any));
      verifyNever(navigatorState.pop());
      verifyNever(navigatorState.popUntil(any));
      verifyNever(navigatorState.pushNamedAndRemoveUntil(any, any));
      verify(navigatorState.pushNamed('/name', arguments: arguments));
    });

    test('should call pushReplacementNamed on currentState', () {
      final store = MockStore();
      final navigatorState = MockNavigatorState();

      NavigationMiddleware(currentState: navigatorState)
          .call(store, NavigateToAction.replace('/name'), (_) {});

      verifyNever(navigatorState.pushNamed(any));
      verifyNever(navigatorState.pop());
      verifyNever(navigatorState.popUntil(any));
      verifyNever(navigatorState.pushNamedAndRemoveUntil(any, any));
      verify(navigatorState.pushReplacementNamed('/name'));
    });

    test('should call pushReplacementNamed on currentState with arguments', () {
      final store = MockStore();
      final navigatorState = MockNavigatorState();
      final arguments = {};

      NavigationMiddleware(currentState: navigatorState).call(store,
          NavigateToAction.replace('/name', arguments: arguments), (_) {});

      verifyNever(navigatorState.pushNamed(any));
      verifyNever(navigatorState.pop());
      verifyNever(navigatorState.popUntil(any));
      verifyNever(navigatorState.pushNamedAndRemoveUntil(any, any));
      verify(
          navigatorState.pushReplacementNamed('/name', arguments: arguments));
    });

    test('should call pop on currentState', () {
      final store = MockStore();
      final navigatorState = MockNavigatorState();

      NavigationMiddleware(currentState: navigatorState)
          .call(store, NavigateToAction.pop(), (_) {});

      verifyNever(navigatorState.pushNamed(any));
      verifyNever(navigatorState.popUntil(any));
      verifyNever(navigatorState.pushReplacementNamed(any));
      verifyNever(navigatorState.pushNamedAndRemoveUntil(any, any));
      verify(navigatorState.pop());
    });

    test('should call pop on currentState', () {
      final store = MockStore();
      final navigatorState = MockNavigatorState();

      NavigationMiddleware(currentState: navigatorState)
          .call(store, NavigateToAction.pop(), (_) {});

      verifyNever(navigatorState.pushNamed(any));
      verifyNever(navigatorState.popUntil(any));
      verifyNever(navigatorState.pushReplacementNamed(any));
      verifyNever(navigatorState.pushNamedAndRemoveUntil(any, any));
      verify(navigatorState.pop());
    });

    test('should call pushNamedAndRemoveUntil on currentState', () {
      final store = MockStore();
      final navigatorState = MockNavigatorState();
      final predicate = (Route<dynamic> route) => false;

      NavigationMiddleware(currentState: navigatorState).call(store,
          NavigateToAction.pushNamedAndRemoveUntil('name', predicate), (_) {});

      verifyNever(navigatorState.pushNamed(any));
      verifyNever(navigatorState.pushReplacementNamed(any));
      verifyNever(navigatorState.pop());
      verifyNever(navigatorState.popUntil(any));
      verify(navigatorState.pushNamedAndRemoveUntil('name', predicate));
    });

    test('should call popUntil on currentState', () {
      final store = MockStore();
      final navigatorState = MockNavigatorState();
      final predicate = (Route<dynamic> route) => false;

      NavigationMiddleware(currentState: navigatorState)
          .call(store, NavigateToAction.popUntil(predicate: predicate), (_) {});

      verifyNever(navigatorState.pushNamed(any));
      verifyNever(navigatorState.pushReplacementNamed(any));
      verifyNever(navigatorState.pop());
      verifyNever(navigatorState.pushNamedAndRemoveUntil(any, any));
      verify(navigatorState.popUntil(predicate));
    });
  });

  group('navigation hooks', () {
    test('should call preNavigation before the actual navigation', () {
      final store = MockStore();
      final navigatorState = MockNavigatorState();
      final log = [];

      when(navigatorState.pushNamed('/name'))
          .thenAnswer((_) async => log.add('/name'));

      NavigationMiddleware(currentState: navigatorState).call(
          store,
          NavigateToAction.push('/name',
              preNavigation: () => log.add('preNavigation')),
          (_) {});

      expect(log, ['preNavigation', '/name']);
    });

    test('should call postNavigation after the actual navigation', () {
      final store = MockStore();
      final navigatorState = MockNavigatorState();
      final log = [];

      when(navigatorState.pushNamed('/name'))
          .thenAnswer((_) async => log.add('/name'));

      NavigationMiddleware(currentState: navigatorState).call(
          store,
          NavigateToAction.push('/name',
              postNavigation: () => log.add('postNavigation')),
          (_) {});

      expect(log, ['/name', 'postNavigation']);
    });

    test('should call both pre and post hooks around the actual navigation',
        () {
      final store = MockStore();
      final navigatorState = MockNavigatorState();
      final log = [];

      when(navigatorState.pushNamed('/name'))
          .thenAnswer((_) async => log.add('/name'));

      NavigationMiddleware(currentState: navigatorState).call(
          store,
          NavigateToAction.push(
            '/name',
            preNavigation: () => log.add('preNavigation'),
            postNavigation: () => log.add('postNavigation'),
          ),
          (_) {});

      expect(log, ['preNavigation', '/name', 'postNavigation']);
    });
  });

  group('state', () {
    test(
        'should start by keeping only the currentPath in the state on initial push transition',
        () {
      final store = MockStore();
      final navigatorState = MockNavigatorState();

      NavigationMiddleware(currentState: navigatorState)
          .call(store, NavigateToAction.push('/name'), (_) {});

      expect(NavigatorHolder.state.currentDestination.path, '/name');
      expect(NavigatorHolder.state.previousDestination, isNull);
    });

    test(
        'should start by keeping only the currentPath in the state on initial replace transition',
        () {
      final store = MockStore();
      final navigatorState = MockNavigatorState();

      NavigationMiddleware(currentState: navigatorState)
          .call(store, NavigateToAction.replace('/name'), (_) {});

      expect(NavigatorHolder.state.currentDestination.path, '/name');
      expect(NavigatorHolder.state.previousDestination, isNull);
    });

    test(
        'should store currentPath as the previousPath on every push transition',
        () {
      final store = MockStore();
      final navigatorState = MockNavigatorState();
      final middleware = NavigationMiddleware(currentState: navigatorState);

      middleware.call(store, NavigateToAction.push('/first'), (_) {});
      middleware.call(store, NavigateToAction.push('/second'), (_) {});

      expect(NavigatorHolder.state.currentDestination.path, '/second');
      expect(NavigatorHolder.state.previousDestination.path, '/first');
    });

    test(
        'should store currentPath as the previousPath on every replace transition',
        () {
      final store = MockStore();
      final navigatorState = MockNavigatorState();
      final middleware = NavigationMiddleware(currentState: navigatorState);

      middleware.call(store, NavigateToAction.replace('/first'), (_) {});
      middleware.call(store, NavigateToAction.replace('/second'), (_) {});

      expect(NavigatorHolder.state.currentDestination.path, '/second');
      expect(NavigatorHolder.state.previousDestination.path, '/first');
    });

    test('should reverse the path order on every pop transition', () {
      final store = MockStore();
      final navigatorState = MockNavigatorState();
      final middleware = NavigationMiddleware(currentState: navigatorState);

      middleware.call(store, NavigateToAction.push('/first'), (_) {});
      middleware.call(store, NavigateToAction.push('/second'), (_) {});
      middleware.call(store, NavigateToAction.pop(), (_) {});

      expect(NavigatorHolder.state.currentDestination.path, '/first');
      expect(NavigatorHolder.state.previousDestination.path, '/second');
    });

    test('should keep initial state when initial navigation is pop', () {
      final store = MockStore();
      final navigatorState = MockNavigatorState();
      final middleware = NavigationMiddleware(currentState: navigatorState);

      middleware.call(store, NavigateToAction.pop(), (_) {});

      expect(NavigatorHolder.state.currentDestination, isNull);
      expect(NavigatorHolder.state.previousDestination, isNull);
    });

    test('should keep initial state when initial navigation is popped until',
        () {
      final store = MockStore();
      final navigatorState = MockNavigatorState();
      final middleware = NavigationMiddleware(currentState: navigatorState);

      middleware.call(
          store, NavigateToAction.popUntil(predicate: (_) => false), (_) {});

      expect(NavigatorHolder.state.currentDestination, isNull);
      expect(NavigatorHolder.state.previousDestination, isNull);
    });

    test(
        'should report current path as null and previous path correctly when all navigations are popped',
        () {
      final store = MockStore();
      final navigatorState = MockNavigatorState();
      final middleware = NavigationMiddleware(currentState: navigatorState);

      middleware.call(store, NavigateToAction.push('/first'), (_) {});
      middleware.call(store, NavigateToAction.push('/second'), (_) {});
      middleware.call(
          store, NavigateToAction.popUntil(predicate: (_) => false), (_) {});

      expect(NavigatorHolder.state.currentDestination, isNull);
      expect(NavigatorHolder.state.previousDestination.path, '/second');
    });
  });
}
