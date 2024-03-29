import 'package:rent_checklist/src/common/utils/extensions.dart';
import 'package:rent_checklist/src/detail/flat_detail_model.dart';
import 'package:rent_checklist/src/detail/item/item_api.dart';
import 'package:rent_checklist/src/detail/network/flat_detail_items_response.dart';
import 'package:rent_checklist/src/flat/flat_api.dart';
import 'package:rent_checklist/src/detail/group/group_api.dart';
import 'package:rent_checklist/src/detail/group/group_model.dart';
import 'package:rent_checklist/src/detail/item/item_model.dart';

class FlatDetailFacade {
  final FlatApi _flatApi;
  final GroupApi _groupApi;
  final ItemApi _itemApi;

  FlatDetailFacade({required flatApi, required groupApi, required itemApi})
      : _flatApi = flatApi,
        _groupApi = groupApi,
        _itemApi = itemApi;

  Future<FlatDetailModel> requestFlatDetails(int flatId) async {
    List<FlatDetailItemsResponse> info = await _flatApi.getItems(flatId);

    if (info.isEmpty) {
      return const FlatDetailModel(groups: {});
    }

    List<int> groupIds = info.map((it) => it.groupId).toList();
    Map<int, GroupModel> groups = await _groupApi.getGroupsByIds(groupIds);

    final items = info
        .map((it) =>
            FlatDetailGroup(
                group: groups[it.groupId]!,
                items: it.items
                    .map((it) => ItemWithStatus(item: it.item, status: it.status))
                    .associateBy((it) => it.item.id),
            )
        )
        .associateBy((it) => it.group.id);

    return FlatDetailModel(groups: items);
  }

  Future<void> changeItemStatus(
      int flatId, int groupId, int itemId, ItemStatus newStatus,
  ) async {
    await _itemApi.changeStatus(flatId, groupId, itemId, newStatus);
  }

  Future<FlatDetailGroup> createAndAddGroup(
      int flatId,
      GroupModel groupModel
  ) async {
    final newGroup = await _groupApi.createGroup(groupModel);
    await _flatApi.addGroupToFlat(flatId, newGroup.id);
    return FlatDetailGroup(
        group: newGroup,
        items: {}
    );
  }

  Future<FlatDetailGroup> addGroupToFlat({
    required int flatId,
    required GroupModel group,
  }) async {
    await _flatApi.addGroupToFlat(flatId, group.id);
    return FlatDetailGroup(
        group: group,
        items: {}
    );
  }

  Future<void> deleteGroupFromFlat({
    required int flatId,
    required GroupModel group,
  }) async {
    await _flatApi.deleteGroupFromFlat(flatId, group.id);
  }

  Future<ItemWithStatus> createAndAddItem({
    required int flatId,
    required int groupId,
    required ItemModel item
  }) async {
    final newItem = await _itemApi.createItem(item);
    await _groupApi.addItemToGroup(flatId, groupId, newItem.id);
    return ItemWithStatus(item: newItem, status: ItemStatus.unset);
  }

  Future<ItemWithStatus> addItemToFlat({
    required int flatId,
    required int groupId,
    required ItemModel item,
  }) async {
    await _groupApi.addItemToGroup(flatId, groupId, item.id);
    return ItemWithStatus(
        item: item,
        status: ItemStatus.unset
    );
  }

  Future<void> deleteItemFromGroup({
    required int flatId,
    required int groupId,
    required int itemId,
  }) async {
    await _groupApi.deleteItemFromGroup(flatId, groupId, itemId);
  }
}
