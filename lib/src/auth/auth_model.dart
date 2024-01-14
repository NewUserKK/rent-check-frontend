import 'package:rent_checklist/src/auth/network/auth_api.dart';
import 'package:rent_checklist/src/auth/auth_state.dart';
import 'package:rent_checklist/src/auth/network/auth_credentials_request.dart';
import 'package:rent_checklist/src/common/arch/view_model.dart';

class AuthEvent {}

class AuthEventRegistrationFailed extends AuthEvent {
  final Object error;
  AuthEventRegistrationFailed(this.error);
}


class AuthModel extends ViewModel<AuthState, AuthEvent> {
  final AuthApi _authApi = AuthApiFactory.create();

  @override
  AuthState state = NotAuthorized();

  Future<void> login(String login, String password) async {
    try {
      final authResponse = await _authApi.login(AuthCredentialsRequest(
        login: login,
        password: password,
      ));
      setState(Authorized(token: authResponse.token));
    } catch (e) {
      setState(NotAuthorized());
    }
  }

  Future<void> register(String login, String password) async {
    try {
      await _authApi.register(AuthCredentialsRequest(
        login: login,
        password: password,
      ));
    } catch (e) {
      emitEvent(AuthEventRegistrationFailed(e));
    }
  }

  Future<void> logout() async {
    setState(NotAuthorized());
    await _authApi.logout();
  }
}
