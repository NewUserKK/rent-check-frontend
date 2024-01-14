import 'package:rent_checklist/src/auth/network/auth_credentials_request.dart';
import 'package:rent_checklist/src/auth/network/auth_login_response.dart';
import 'package:rent_checklist/src/common/experiments/features.dart';
import 'package:rent_checklist/src/common/network/api_utils.dart';
import 'package:rent_checklist/src/common/network/client.dart';

abstract interface class AuthApi {
  Future<void> register(AuthCredentialsRequest credentials);
  Future<AuthLoginResponse> login(AuthCredentialsRequest credentials);
  Future<void> logout();
}

class AuthApiFactory {
  static AuthApi create() {
    return Features.useFakeApi.isEnabled ? FakeAuthApi() : NetworkAuthApi();
  }
}


class NetworkAuthApi implements AuthApi {
  @override
  Future<void> register(AuthCredentialsRequest credentials) async {
    await request(() => kClient.post(
      'auth/register',
      data: credentials.toJson(),
    ));
  }

  @override
  Future<AuthLoginResponse> login(AuthCredentialsRequest credentials) async {
    final response = await requestAndDecode(() => kClient.post(
      'auth/login',
      data: credentials.toJson(),
    ));

    return AuthLoginResponse.fromJson(response);
  }

  @override
  Future<void> logout() async {
    await request(() => kClient.post('auth/logout'));
  }
}


class FakeAuthApi implements AuthApi {
  @override
  Future<void> register(AuthCredentialsRequest credentials) async {
    await Future.delayed(const Duration(seconds: 1));
  }

  @override
  Future<AuthLoginResponse> login(AuthCredentialsRequest credentials) async {
    await Future.delayed(const Duration(seconds: 1));
    return const AuthLoginResponse(token: 'fake_vs_reality');
  }

  @override
  Future<void> logout() async {
    await Future.delayed(const Duration(seconds: 1));
  }
}
