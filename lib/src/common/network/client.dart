import 'package:dio/dio.dart';
import 'package:rent_checklist/src/common/network/endpoints.dart';

final kClient = Dio(
  BaseOptions(
    baseUrl: Endpoints.apiV1,
  ),
);

void initializeHttpClient() {
  final interceptors = <Interceptor?>[].whereType<Interceptor>();
  kClient.interceptors.addAll(interceptors);
}
