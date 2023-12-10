import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:rent_checklist/src/common/experiments/features.dart';
import 'package:rent_checklist/src/common/network/client.dart';

import 'flat_model.dart';

abstract interface class FlatApi {
  Future<List<FlatModel>> getFlats();
  Future<FlatModel> createFlat(FlatModel flat);
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
      print(e);
      return [];
    }
  }

  @override
  Future<FlatModel> createFlat(FlatModel flat) async {
    try {
      final Response<String> response = await kClient.post(
        'flats',
        data: flat.toJson(),
      );
      final json = jsonDecode(response.data!) as Map<String, dynamic>;
      return FlatModel.fromJson(json);
    } catch (e) {
      print(e);
      return flat;
    }
  }
}

class FakeFlatApi implements FlatApi {
  @override
  Future<List<FlatModel>> getFlats() async {
    try {
      final Response<String> response = Response(
        data: '''[
          {"id": 1, "address": "address 1"},
          {"id": 2, "address": "address 2", "title": "title 2"},
          {"id": 3, "address": "address 3", "description": "description 3"},
          {"id": 4, "address": "address 4", "title": "title 4", "description": "description 4"}
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

  @override
  Future<FlatModel> createFlat(FlatModel flat) async {
    try {
      final Response<String> response = Response(
        data: '''{
          "id": 5,
          "address": "${flat.address}",
          "title": "${flat.title}",
          "description": "${flat.description}"
        }''',
        statusCode: 200,
        requestOptions: RequestOptions(path: 'flats'),
      );

      final json = jsonDecode(response.data!) as Map<String, dynamic>;
      return FlatModel.fromJson(json);
    } catch (e) {
      return flat;
    }
  }
}
