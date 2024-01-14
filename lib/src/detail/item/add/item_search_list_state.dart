import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:rent_checklist/src/detail/item/item_model.dart';

part 'generated/item_search_list_state.freezed.dart';

sealed class ItemSearchListState {}

class ItemSearchListLoading extends ItemSearchListState {}

@freezed
class ItemSearchListError
    extends ItemSearchListState
    with _$ItemSearchListError {

  const factory ItemSearchListError({
    required Object error
  }) = _ItemSearchListError;
}

@freezed
class ItemSearchListLoaded
    extends ItemSearchListState
    with _$ItemSearchListLoaded {

  const factory ItemSearchListLoaded({
    required List<ItemModel> items
  }) = _ItemSearchListLoaded;
}
