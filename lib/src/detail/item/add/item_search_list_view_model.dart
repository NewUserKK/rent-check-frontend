import 'package:rent_checklist/src/common/arch/view_model.dart';
import 'package:rent_checklist/src/detail/item/add/item_search_list_state.dart';
import 'package:rent_checklist/src/detail/item/item_api.dart';

sealed class ItemSearchListViewEvent {}

class ItemSearchListViewModel extends ViewModel<
    ItemSearchListState,
    ItemSearchListViewEvent
> {
  final ItemApi _itemApi = ItemApiFactory.create();

  @override
  ItemSearchListState state = ItemSearchListLoading();

  void load() async {
    try {
      setState(ItemSearchListLoading());

      final items = await _itemApi.getItems();
      setState(ItemSearchListLoaded(items: items));
    } catch (e) {
      setState(ItemSearchListError(error: e));
    }
  }
}
