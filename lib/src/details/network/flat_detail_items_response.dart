import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:rent_checklist/src/details/item/item_model.dart';

part 'generated/flat_detail_items_response.freezed.dart';
part 'generated/flat_detail_items_response.g.dart';

@freezed
class FlatDetailItemsResponse with _$FlatDetailItemsResponse {
  const factory FlatDetailItemsResponse({
    required List<FlatDetailItemWithStatusResponse> items,
    required int groupId,
  }) = _FlatDetailItemsResponse;

  factory FlatDetailItemsResponse.fromJson(Map<String, dynamic> json) =>
      _$FlatDetailItemsResponseFromJson(json);
}

@freezed
class FlatDetailItemWithStatusResponse with _$FlatDetailItemWithStatusResponse {
  const factory FlatDetailItemWithStatusResponse({
    required ItemModel item,
    required ItemStatus status,
  }) = _FlatDetailItemWithStatusResponse;

  factory FlatDetailItemWithStatusResponse.fromJson(Map<String, dynamic> json) =>
      _$FlatDetailItemWithStatusResponseFromJson(json);
}
