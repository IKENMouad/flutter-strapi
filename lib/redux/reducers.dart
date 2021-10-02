import 'package:app1/models/app_state.dart';

AppState appReducer(state, action) {
  return AppState(
    user: userReducer(state.user, action),
  );
}

userReducer(state, action) {
  return state;
}
