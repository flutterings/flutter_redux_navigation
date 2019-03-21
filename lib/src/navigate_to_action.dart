/// The action to be dispatched in the store in order to trigger a navigation.
class NavigateToAction {
  final String name;

  /// If true the [Navigator.pushReplacementNamed] will be called with the
  /// specified [name].
  final bool shouldReplace;

  /// If true the [Navigator.pop] will be called.
  final bool shouldPop;

  /// Optional callback function to be called before the actual navigation.
  /// e.g. activate the loader.
  final Function preNavigation;

  /// Optional callback function to be called after the actual navigation.
  /// e.g. de-activate the loader.
  final Function postNavigation;

  /// Create a navigation action.
  ///
  /// The [name], [shouldReplace] and [shouldPop] parameters must not be null
  /// and only one of them can be true.
  /// The [preNavigation] and [postNavigation] parameters are optional.
  NavigateToAction(this.name, this.shouldReplace, this.shouldPop,
      this.preNavigation, this.postNavigation)
      : assert(shouldReplace != null),
        assert(shouldPop != null),
        assert(!(shouldPop && shouldReplace));

  factory NavigateToAction.push(String name,
          {Function preNavigation, Function postNavigation}) =>
      NavigateToAction(name, false, false, preNavigation, postNavigation);

  factory NavigateToAction.pop(
          {Function preNavigation, Function postNavigation}) =>
      NavigateToAction(null, false, true, preNavigation, postNavigation);

  factory NavigateToAction.replace(String name,
          {Function preNavigation, Function postNavigation}) =>
      NavigateToAction(name, true, false, preNavigation, postNavigation);
}
