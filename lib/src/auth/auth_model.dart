import 'package:rent_checklist/src/auth/network/auth_api.dart';
import 'package:rent_checklist/src/auth/auth_state.dart';
import 'package:rent_checklist/src/auth/network/auth_credentials_request.dart';
import 'package:rent_checklist/src/common/arch/view_model.dart';
import 'package:rent_checklist/src/common/experiments/features.dart';
import 'package:shared_preferences/shared_preferences.dart';

sealed class AuthEvent {}

class AuthEventRegistrationSuccess extends AuthEvent {}

class AuthEventRegistrationFailed extends AuthEvent {
  final Object error;
  AuthEventRegistrationFailed(this.error);
}

class AuthEventLoginFailed extends AuthEvent {
  final Object error;
  AuthEventLoginFailed(this.error);
}


class AuthModel extends ViewModel<AuthState, AuthEvent> {
  static const sKeyToken = 'auth_token';

  final AuthApi _authApi = AuthApiFactory.create();

  @override
  AuthState state = NotAuthorized();

  Future<bool> restoreAuth() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(sKeyToken);
    final hasToken = token != null;
    if (hasToken) {
      setState(Authorized(token: token));
    }

    return hasToken;
  }

  Future<void> login(String login, String password) async {
    try {
      final authResponse = await _authApi.login(AuthCredentialsRequest(
        login: login,
        password: password,
      ));

      _setAuthorized(Authorized(token: authResponse.token));

    } catch (e) {
      if (Features.useTestAuth.isEnabled) {
        _setAuthorized(const Authorized(token: 'test2'));
      } else {
        _setNotAuthorized();
        emitEvent(AuthEventLoginFailed(e));
      }
    }
  }

  Future<void> register(String login, String password) async {
    try {
      await _authApi.register(AuthCredentialsRequest(
        login: login,
        password: password,
      ));
      emitEvent(AuthEventRegistrationSuccess());
    } catch (e) {
      emitEvent(AuthEventRegistrationFailed(e));
    }
  }

  Future<void> logout() async {
    try {
      await _authApi.logout();
    } finally {
      _setNotAuthorized();
    }
  }

  Future<void> _setAuthorized(Authorized state) async {
    setState(state);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(sKeyToken, state.token);
  }

  Future<void> _setNotAuthorized() async {
    setState(NotAuthorized());
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(sKeyToken);
  }
}
