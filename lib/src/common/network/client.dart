import 'package:dio/dio.dart';
import 'package:rent_checklist/src/common/network/endpoints.dart';
import 'package:rent_checklist/src/common/network/interceptors/auth_interceptor.dart';

final kClient = Dio(
  BaseOptions(
    baseUrl: Endpoints.apiV1,
  ),
);

void initializeHttpClient() {
  final interceptors = <Interceptor?>[
    AuthInterceptor(),
  ].whereType<Interceptor>();
  kClient.interceptors.addAll(interceptors);
}
