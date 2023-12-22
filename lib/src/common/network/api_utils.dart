import 'dart:convert';

import 'package:dio/dio.dart';

class NetworkError {
  final int errorCode;
  final String errorMessage;
  final DioException? originException;

  NetworkError({
    required this.errorCode,
    this.errorMessage = '',
    this.originException,
  });

  @override
  String toString() {
    return "NetworkError(errorCode=$errorCode, errorMessage=$errorMessage, originException=$originException)";
  }
}


Future<Response<String>> request(
    Future<Response<String>> Function() makeRequest
) async {
  try {
    final Response<String> response = await makeRequest();
    return response;
  } on DioException catch (e) {
    throw NetworkError(
      errorCode: e.response?.statusCode ?? 0,
      errorMessage: e.response?.data.toString() ?? '',
      originException: e,
    );
  }
}


Future<Map<String, dynamic>> requestAndDecode(
    Future<Response<String>> Function() makeRequest
) async {
  return _requestAndDecodeAs<Map<String, dynamic>>(makeRequest);
}


Future<Iterable> requestAndDecodeToList(
    Future<Response<String>> Function() makeRequest
) async {
  await Future.delayed(const Duration(milliseconds: 1000));
  return _requestAndDecodeAs<Iterable>(makeRequest);
}


Future<T> _requestAndDecodeAs<T>(
    Future<Response<String>> Function() makeRequest,
) async {
  final response = await request(makeRequest);
  return jsonDecode(response.data!) as T;
}


Response<String> fakeResponseOf(String path, String json) {
  return Response(
    data: json,
    statusCode: 200,
    requestOptions: RequestOptions(path: path),
  );
}
