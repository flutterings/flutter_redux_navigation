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
  group('NavigateToAction', () {
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
  });

  group('NavigationState', () {
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
  });

  group('NavigationMiddleware', () {
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

        verify(navigatorState.pushNamed('/name'));
        verifyNever(navigatorState.pushReplacementNamed(any));
        verifyNever(navigatorState.pop());
      });

      test('should call pushReplacementNamed on currentState', () {
        final store = MockStore();
        final navigatorState = MockNavigatorState();

        NavigationMiddleware(currentState: navigatorState)
            .call(store, NavigateToAction.replace('/name'), (_) {});

        verifyNever(navigatorState.pushNamed(any));
        verify(navigatorState.pushReplacementNamed('/name'));
        verifyNever(navigatorState.pop());
      });

      test('should call pop on currentState', () {
        final store = MockStore();
        final navigatorState = MockNavigatorState();

        NavigationMiddleware(currentState: navigatorState)
            .call(store, NavigateToAction.pop(), (_) {});

        verifyNever(navigatorState.pushNamed(any));
        verifyNever(navigatorState.pushReplacementNamed(any));
        verify(navigatorState.pop());
      });

      test('should call pop on currentState', () {
        final store = MockStore();
        final navigatorState = MockNavigatorState();

        NavigationMiddleware(currentState: navigatorState)
            .call(store, NavigateToAction.pop(), (_) {});

        verifyNever(navigatorState.pushNamed(any));
        verifyNever(navigatorState.pushReplacementNamed(any));
        verify(navigatorState.pop());
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

        expect(NavigatorHolder.state.currentPath, '/name');
        expect(NavigatorHolder.state.previousPath, isNull);
      });

      test(
          'should start by keeping only the currentPath in the state on initial replace transition',
          () {
        final store = MockStore();
        final navigatorState = MockNavigatorState();

        NavigationMiddleware(currentState: navigatorState)
            .call(store, NavigateToAction.replace('/name'), (_) {});

        expect(NavigatorHolder.state.currentPath, '/name');
        expect(NavigatorHolder.state.previousPath, isNull);
      });

      test(
          'should store currentPath as the previousPath on every push transition',
          () {
        final store = MockStore();
        final navigatorState = MockNavigatorState();
        final middleware = NavigationMiddleware(currentState: navigatorState);

        middleware.call(store, NavigateToAction.push('/first'), (_) {});
        middleware.call(store, NavigateToAction.push('/second'), (_) {});

        expect(NavigatorHolder.state.currentPath, '/second');
        expect(NavigatorHolder.state.previousPath, '/first');
      });

      test(
          'should store currentPath as the previousPath on every replace transition',
          () {
        final store = MockStore();
        final navigatorState = MockNavigatorState();
        final middleware = NavigationMiddleware(currentState: navigatorState);

        middleware.call(store, NavigateToAction.replace('/first'), (_) {});
        middleware.call(store, NavigateToAction.replace('/second'), (_) {});

        expect(NavigatorHolder.state.currentPath, '/second');
        expect(NavigatorHolder.state.previousPath, '/first');
      });

      test('should reverse the path order on every pop transition', () {
        final store = MockStore();
        final navigatorState = MockNavigatorState();
        final middleware = NavigationMiddleware(currentState: navigatorState);

        middleware.call(store, NavigateToAction.push('/first'), (_) {});
        middleware.call(store, NavigateToAction.push('/second'), (_) {});
        middleware.call(store, NavigateToAction.pop(), (_) {});

        expect(NavigatorHolder.state.currentPath, '/first');
        expect(NavigatorHolder.state.previousPath, '/second');
      });

      test('should keep initial state when initial navigation is pop', () {
        final store = MockStore();
        final navigatorState = MockNavigatorState();
        final middleware = NavigationMiddleware(currentState: navigatorState);

        middleware.call(store, NavigateToAction.pop(), (_) {});

        expect(NavigatorHolder.state.currentPath, isNull);
        expect(NavigatorHolder.state.previousPath, isNull);
      });
    });
  });
}
