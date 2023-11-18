import 'package:dio/dio.dart';
import 'package:rent_checklist/src/common/network/api.dart';

final kClient = Dio(
  BaseOptions(
    baseUrl: Api.v1,
  ),
);
