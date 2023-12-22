import 'package:rent_checklist/src/common/utils/extensions.dart';
import 'package:rent_checklist/src/details/flat_detail_model.dart';
import 'package:rent_checklist/src/details/network/flat_detail_items_response.dart';
import 'package:rent_checklist/src/flat/flat_api.dart';
import 'package:rent_checklist/src/details/group/group_api.dart';
import 'package:rent_checklist/src/details/group/group_model.dart';
import 'package:rent_checklist/src/details/item/item_model.dart';

class FlatDetailFacade {
  final FlatApi flatApi;
  final GroupApi groupApi;

  FlatDetailFacade({required this.flatApi, required this.groupApi});

  Future<FlatDetailModel> requestFlatDetails(int flatId) async {
    List<FlatDetailItemsResponse> info = await flatApi.getItems(flatId);

    List<int> groupIds = info.map((it) => it.groupId).toList();
    Map<int, GroupModel> groups = await groupApi.getGroupsByIds(groupIds);

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
}
