/// It keeps the current and previous path of the navigation.
class NavigationState {
  final String previousPath;
  final Object previousArguments;
  final String currentPath;
  final Object currentArguments;

  NavigationState(this.previousPath, this.previousArguments, this.currentPath, this.currentArguments);

  factory NavigationState.initial() => NavigationState(null, null, null, null);

  factory NavigationState.transition(String previousPath, Object previousArguments, String currentPath, Object currentArgument) =>
      NavigationState(previousPath, previousArguments, currentPath, currentArgument);
}
