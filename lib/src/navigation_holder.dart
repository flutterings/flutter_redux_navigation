import 'package:flutter/widgets.dart';

import 'navigation_state.dart';

/// Provides a way to keep a reference of the [NavigatorState] globally.
/// It also keeps a global reference of the [NavigationState].
class NavigatorHolder {
  static final navigatorKey = GlobalKey<NavigatorState>();
  static NavigationState? state;
}
