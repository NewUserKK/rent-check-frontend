import 'package:rent_checklist/src/common/experiments/features.dart';
import 'package:rent_checklist/src/common/network/api_utils.dart';
import 'package:rent_checklist/src/common/network/client.dart';
import 'package:rent_checklist/src/flat/details/network/flat_detail_items_response.dart';

import 'flat_model.dart';

abstract interface class FlatApi {
  Future<List<FlatModel>> getFlats();
  Future<FlatModel> createFlat(FlatModel flat);
  Future<List<FlatDetailItemsResponse>> getItems(int flatId);
}

class FlatApiFactory {
  static FlatApi create() {
    return Features.useFakeApi.isEnabled ? FakeFlatApi() : NetworkFlatApi();
  }
}

class NetworkFlatApi implements FlatApi {
  @override
  Future<List<FlatModel>> getFlats() async {
    final json = await requestAndDecodeToList(() => kClient.get('flats'));
    return json.map((v) => FlatModel.fromJson(v)).toList();
  }

  @override
  Future<FlatModel> createFlat(FlatModel flat) async {
    final json = await requestAndDecode(
        () => kClient.post('flats', data: flat.toJson()));
    return FlatModel.fromJson(json);
  }

  @override
  Future<List<FlatDetailItemsResponse>> getItems(int flatId) async {
    final json = await requestAndDecodeToList(
            () => kClient.get('flats/$flatId/items')
    );
    return json.map((v) => FlatDetailItemsResponse.fromJson(v)).toList();
  }
}

class FakeFlatApi implements FlatApi {
  @override
  Future<List<FlatModel>> getFlats() async {
    final response = fakeResponseOf(
      'flats',
      '''[
        {"id": 1, "address": "address 1"},
        {"id": 2, "address": "address 2", "title": "title 2"},
        {"id": 3, "address": "address 3", "description": "description 3"},
        {"id": 4, "address": "address 4", "title": "title 4", "description": "description 4"}
      ]'''
    );
    final json = await requestAndDecodeToList(() => Future.value(response));
    return json.map((v) => FlatModel.fromJson(v)).toList();
  }

  @override
  Future<FlatModel> createFlat(FlatModel flat) async {
    final response = fakeResponseOf(
      'flats',
      '''{
        "id": 5,
        "address": "${flat.address}",
        "title": "${flat.title}",
        "description": "${flat.description}"
      }'''
    );

    final json = await requestAndDecode(() => Future.value(response));
    return FlatModel.fromJson(json);
  }

  @override
  Future<List<FlatDetailItemsResponse>> getItems(int flatId) async {
    final response = fakeResponseOf(
      'flats/$flatId/items',
      '''[
        {
          "items": [
            {"item": {"id": 1, "title": "item 1"}, "status": "ok"},
            {"item": {"id": 2, "title": "item 2"}, "status": "ok"},
            {"item": {"id": 3, "title": "item 3"}, "status": "meh"},
            {"item": {"id": 4, "title": "item 4"}, "status": "not-ok"}
          ],
          "groupId": 1
        },
        {
          "items": [
            {"item": {"id": 5, "title": "item 5"}, "status": "ok"},
            {"item": {"id": 6, "title": "item 6"}, "status": "ok"},
            {"item": {"id": 7, "title": "item 7"}, "status": "ok"},
            {"item": {"id": 8, "title": "item 8"}, "status": "meh"}
          ],
          "groupId": 2
        }
      ]'''
    );

    final json = await requestAndDecodeToList(() => Future.value(response));
    return json.map((v) => FlatDetailItemsResponse.fromJson(v)).toList();
  }
}
