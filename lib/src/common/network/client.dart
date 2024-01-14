import 'package:dio/dio.dart';
import 'package:rent_checklist/src/auth/auth_model.dart';
import 'package:rent_checklist/src/common/network/endpoints.dart';
import 'package:rent_checklist/src/auth/network/auth_interceptor.dart';

final kClient = Dio(
  BaseOptions(
    baseUrl: Endpoints.apiV1,
  ),
);

void initializeHttpClient({required AuthModel authModel}) {
  final interceptors = <Interceptor?>[
    AuthInterceptor(authModel: authModel),
  ].whereType<Interceptor>();
  kClient.interceptors.addAll(interceptors);
}
