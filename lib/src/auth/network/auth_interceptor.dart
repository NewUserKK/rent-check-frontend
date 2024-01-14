import 'package:dio/dio.dart';
import 'package:rent_checklist/src/auth/auth_model.dart';
import 'package:rent_checklist/src/auth/auth_state.dart';

class AuthInterceptor extends Interceptor {
  final AuthModel _authModel;

  AuthInterceptor({required AuthModel authModel}): _authModel = authModel;

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) {
    final authState = _authModel.state;
    if (authState is Authorized) {
      options.headers.addAll({
        'Authorization': 'Bearer ${authState.token}'
      });
    }

    handler.next(options);
  }

  @override
  void onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) {
    if (err.response?.statusCode == 401) {
      _authModel.logout();
    }

    handler.next(err);
  }
}
