/// It keeps the current and previous path of the navigation.
class NavigationState {
  final String previousPath;
  final String currentPath;

  NavigationState(this.previousPath, this.currentPath);

  factory NavigationState.initial() => NavigationState(null, null);

  factory NavigationState.transition(String previousPath, String currentPath) =>
      NavigationState(previousPath, currentPath);
}