import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:rent_checklist/src/common/experiments/features.dart';
import 'package:rent_checklist/src/common/network/client.dart';

import 'flat_model.dart';

abstract interface class FlatApi {
  Future<List<FlatModel>> getFlats();
}

class FlatApiFactory {
  static FlatApi create() {
    return Features.useFakeApi.isEnabled ? FakeFlatApi() : NetworkFlatApi();
  }
}

class NetworkFlatApi implements FlatApi {
  @override
  Future<List<FlatModel>> getFlats() async {
    try {
      final Response<String> response = await kClient.get('flats');
      final json = jsonDecode(response.data!) as Iterable;
      return json.map((v) => FlatModel.fromJson(v)).toList();
    } catch (e) {
      return [];
    }
  }
}

class FakeFlatApi implements FlatApi {
  @override
  Future<List<FlatModel>> getFlats() async {
    try {
      final Response<String> response = Response(
        data: '''[
          {"id": 1, "title": "title 1", "description": "description", "address": "address"},
          {"id": 2, "title": "title 2", "description": "description", "address": "address"},
          {"id": 3, "title": "title 3", "description": "description", "address": "address"},
          {"id": 4, "title": "title 4", "description": "description", "address": "address"},
          {"id": 5, "title": "title 5", "description": "description", "address": "address"},
          {"id": 6, "title": "title 6", "description": "description", "address": "address"},
          {"id": 7, "title": "title 7", "description": "description", "address": "address"}
        ]''',
        statusCode: 200,
        requestOptions: RequestOptions(path: 'flats'),
      );

      final json = jsonDecode(response.data!) as Iterable;
      return json.map((v) => FlatModel.fromJson(v)).toList();
    } catch (e) {
      return [];
    }
  }
}
