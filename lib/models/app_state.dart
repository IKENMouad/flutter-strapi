import 'package:meta/meta.dart';

@immutable
class AppState {
  final dynamic user;

  const AppState({this.user});

  factory AppState.intial() {
    return const AppState(user: null);
  }
}
