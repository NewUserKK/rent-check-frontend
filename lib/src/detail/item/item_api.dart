import 'package:rent_checklist/src/common/experiments/features.dart';
import 'package:rent_checklist/src/common/network/api_utils.dart';
import 'package:rent_checklist/src/common/network/client.dart';
import 'package:rent_checklist/src/detail/item/item_model.dart';

abstract interface class ItemApi {
  Future<List<ItemModel>> getItems();

  Future<ItemModel> createItem(ItemModel item);

  Future<void> changeStatus(
      int flatId,
      int groupId,
      int itemId,
      ItemStatus status
  );
}


class ItemApiFactory {
  static ItemApi create() {
    return Features.useFakeApi.isEnabled ? FakeItemApi() : NetworkItemApi();
  }
}


class NetworkItemApi implements ItemApi {
  @override
  Future<List<ItemModel>> getItems() async {
    final json = await requestAndDecodeToList(() => kClient.get('items'));
    return json.map((v) => ItemModel.fromJson(v)).toList();
  }

  @override
  Future<ItemModel> createItem(ItemModel item) async {
    final json = await requestAndDecode(() => kClient.post(
      'items',
      data: item.toJson(),
    ));
    return ItemModel.fromJson(json);
  }

  @override
  Future<void> changeStatus(
      int flatId,
      int groupId,
      int itemId,
      ItemStatus status
  ) async {
    await request(() => kClient.post(
        'items/status',
        data: {
          'itemId': itemId,
          'groupId': groupId,
          'flatId': flatId,
          'status': status.toJson()
        }
    ));
  }
}

class FakeItemApi implements ItemApi {
  @override
  Future<List<ItemModel>> getItems() async {
    await Future.delayed(const Duration(milliseconds: 1000));

    return [
      const ItemModel(
        id: 1,
        title: "Кровать",
      ),
      const ItemModel(
        id: 2,
        title: "Шкаф",
      ),
      const ItemModel(
        id: 3,
        title: "Стол",
      ),
    ];
  }

  @override
  Future<ItemModel> createItem(ItemModel item) async {
    return item.copyWith(id: 9999);
  }

  @override
  Future<void> changeStatus(
      int flatId,
      int groupId,
      int itemId,
      ItemStatus status
  ) async {
    await Future.delayed(const Duration(milliseconds: 1000));
  }
}
