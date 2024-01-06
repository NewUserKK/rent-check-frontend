import 'package:rent_checklist/src/common/experiments/features.dart';
import 'package:rent_checklist/src/common/network/api_utils.dart';
import 'package:rent_checklist/src/common/network/client.dart';
import 'package:rent_checklist/src/details/item/item_model.dart';

abstract interface class ItemApi {
  Future<void> changeStatus(
      int flatId,
      int groupId,
      int itemId,
      ItemStatus status
  );
  Future<ItemModel> createItem(ItemModel item);
}


class ItemApiFactory {
  static ItemApi create() {
    return Features.useFakeApi.isEnabled ? FakeItemApi() : NetworkItemApi();
  }
}


class NetworkItemApi implements ItemApi {
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

  @override
  Future<ItemModel> createItem(ItemModel item) async {
    final json = await requestAndDecode(() => kClient.post(
        'items',
        data: item.toJson(),
    ));
    return ItemModel.fromJson(json);
  }
}

class FakeItemApi implements ItemApi {
  @override
  Future<void> changeStatus(
      int flatId,
      int groupId,
      int itemId,
      ItemStatus status
  ) async {
    await Future.delayed(const Duration(milliseconds: 1000));
  }

  @override
  Future<ItemModel> createItem(ItemModel item) async {
    return item.copyWith(id: 9999);
  }
}
