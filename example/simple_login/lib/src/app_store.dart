import 'package:flutter_redux_navigation/flutter_redux_navigation.dart';
import 'package:redux/redux.dart';


class AppState {

  AppState();

  factory AppState.initial() => AppState();
}

final store = new Store<AppState>(combineReducers<AppState>([]),
    initialState: AppState.initial(),
    middleware: [
      NavigationMiddleware(),
    ]);