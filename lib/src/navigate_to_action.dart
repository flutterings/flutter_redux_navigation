/// Controls the type of navigation method.
enum NavigationType {
  /// The [Navigator.pushReplacementNamed] will be called.
  shouldReplace,

  /// The [Navigator.pop] will be called.
  shouldPop,

  /// The [Navigator.pushNamed] will be called.
  shouldPush,
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

  /// Create a navigation action.
  ///
  /// The [name] parameter must not be null.
  /// The [preNavigation] and [postNavigation] parameters are optional.
  NavigateToAction(this.name,
      {this.type = NavigationType.shouldPush,
      this.preNavigation,
      this.postNavigation})
      : assert(() {
          if (type != NavigationType.shouldPop) {
            return name != null && name.isNotEmpty;
          }
          return true;
        }());

  factory NavigateToAction.push(String name,
          {Function preNavigation, Function postNavigation}) =>
      NavigateToAction(name,
          preNavigation: preNavigation, postNavigation: postNavigation);

  factory NavigateToAction.pop(
          {Function preNavigation, Function postNavigation}) =>
      NavigateToAction(null,
          type: NavigationType.shouldPop,
          preNavigation: preNavigation,
          postNavigation: postNavigation);

  factory NavigateToAction.replace(String name,
          {Function preNavigation, Function postNavigation}) =>
      NavigateToAction(name,
          type: NavigationType.shouldReplace,
          preNavigation: preNavigation,
          postNavigation: postNavigation);
}
