import 'package:rent_checklist/src/common/experiments/features.dart';
import 'package:rent_checklist/src/common/network/api_utils.dart';
import 'package:rent_checklist/src/common/network/client.dart';
import 'package:rent_checklist/src/detail/network/flat_detail_items_response.dart';

import 'flat_model.dart';

abstract interface class FlatApi {
  Future<List<FlatModel>> getFlats();
  Future<FlatModel> createFlat(FlatModel flat);
  Future<void> deleteFlat(int flatId);
  Future<List<FlatDetailItemsResponse>> getItems(int flatId);
  Future<void> addGroupToFlat(int flatId, int groupId);
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
  Future<void> deleteFlat(int flatId) async {
    await request(() => kClient.delete('flats/$flatId'));
  }


  @override
  Future<List<FlatDetailItemsResponse>> getItems(int flatId) async {
    final json = await requestAndDecodeToList(
            () => kClient.get('flats/$flatId/items')
    );
    return json.map((v) => FlatDetailItemsResponse.fromJson(v)).toList();
  }

  @override
  Future<void> addGroupToFlat(int flatId, int groupId) async {
    await kClient.post(
        'flats/$flatId/groups',
        data: {'groupId': groupId}
    );
  }
}

class FakeFlatApi implements FlatApi {
  @override
  Future<List<FlatModel>> getFlats() async {
    const address = "Большеохтинский проспект 154";
    const title = "Квартира с тигром";
    const description = "Большая квартира с большим тигром, тут ещё много текста и описания";

    final response = fakeResponseOf(
      'flats',
      '''[
        {"id": 1, "address": "$address"},
        {"id": 2, "address": "$address", "title": "$title"},
        {"id": 3, "address": "$address", "description": "$description"},
        {"id": 4, "address": "$address", "title": "$title", "description": "$description"}
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
  Future<void> deleteFlat(int flatId) async {
  }

  @override
  Future<List<FlatDetailItemsResponse>> getItems(int flatId) async {
    final response = fakeResponseOf(
      'flats/$flatId/items',
      '''[
        {
          "items": [
            {"item": {"id": 1, "title": "Напор воды"}, "status": "ok"},
            {"item": {"id": 2, "title": "Диван"}, "status": "ok"},
            {"item": {"id": 3, "title": "Вытяжка"}, "status": "meh"},
            {"item": {"id": 4, "title": "Кровать"}, "status": "not-ok"}
          ],
          "groupId": 1
        },
        {
          "items": [
            {"item": {"id": 5, "title": "Ковёр на стене"}, "status": "ok"},
            {"item": {"id": 6, "title": "Стол для работы"}, "status": "ok"},
            {"item": {"id": 7, "title": "Вид из окна"}, "status": "ok"},
            {"item": {"id": 8, "title": "Кот"}, "status": "meh"}
          ],
          "groupId": 2
        },
        {
          "items": [],
          "groupId": 3
        },
        {
          "items": [],
          "groupId": 4
        }
      ]'''
    );

    final json = await requestAndDecodeToList(() => Future.value(response));
    return json.map((v) => FlatDetailItemsResponse.fromJson(v)).toList();
  }

  @override
  Future<void> addGroupToFlat(int flatId, int groupId) async {
    final response = fakeResponseOf(
      'flats/$flatId/groups',
      ''
    );

    await request(() => Future.value(response));
  }
}
