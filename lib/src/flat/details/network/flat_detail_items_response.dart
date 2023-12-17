import 'package:rent_checklist/src/item/item_model.dart';

class FlatDetailItemsResponse {
  final List<FlatDetailItemWithStatusResponse> items;
  final int groupId;

  FlatDetailItemsResponse({required this.items, required this.groupId});

  factory FlatDetailItemsResponse.fromJson(Map<String, dynamic> json) {
    final itemsListRaw = json['items'] as List<dynamic>;
    final itemsList = itemsListRaw.map((v) => FlatDetailItemWithStatusResponse.fromJson(v)).toList();

    return FlatDetailItemsResponse(
      items: itemsList,
      groupId: json['groupId'],
    );
  }
}

class FlatDetailItemWithStatusResponse {
  final ItemModel item;
  final ItemStatus status;

  FlatDetailItemWithStatusResponse({required this.item, required this.status});

  factory FlatDetailItemWithStatusResponse.fromJson(Map<String, dynamic> json) {
    return FlatDetailItemWithStatusResponse(
      item: ItemModel.fromJson(json['item']),
      status: ItemStatus.fromJson(json['status']),
    );
  }
}
