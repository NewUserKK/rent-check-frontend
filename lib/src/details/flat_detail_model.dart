import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:rent_checklist/src/details/group/group_model.dart';
import 'package:rent_checklist/src/details/item/item_model.dart';

part 'generated/flat_detail_model.freezed.dart';

@freezed
class FlatDetailModel with _$FlatDetailModel {
  const factory FlatDetailModel({
    required Map<int, FlatDetailGroup> groups
  }) = _FlatDetailModel;
}

@freezed
class FlatDetailGroup with _$FlatDetailGroup {
  const factory FlatDetailGroup({
    required GroupModel group,
    required Map<int, ItemWithStatus> items
  }) = _FlatDetailGroup;
}
