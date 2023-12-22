import 'package:rent_checklist/src/common/utils/extensions.dart';
import 'package:rent_checklist/src/details/flat_detail_model.dart';
import 'package:rent_checklist/src/details/item/item_api.dart';
import 'package:rent_checklist/src/details/network/flat_detail_items_response.dart';
import 'package:rent_checklist/src/flat/flat_api.dart';
import 'package:rent_checklist/src/details/group/group_api.dart';
import 'package:rent_checklist/src/details/group/group_model.dart';
import 'package:rent_checklist/src/details/item/item_model.dart';

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
}
