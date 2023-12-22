import 'package:rent_checklist/src/common/utils/extensions.dart';
import 'package:rent_checklist/src/common/widgets/view_event_emitter.dart';
import 'package:rent_checklist/src/details/flat_detail_facade.dart';
import 'package:rent_checklist/src/details/flat_detail_state.dart';
import 'package:rent_checklist/src/details/group/group_api.dart';
import 'package:rent_checklist/src/details/item/item_api.dart';
import 'package:rent_checklist/src/details/item/item_model.dart';
import 'package:rent_checklist/src/flat/flat_api.dart';
import 'package:rent_checklist/src/flat/flat_model.dart';

sealed class FlatDetailViewEvent {}
class FlatDetailEventChangeItemStatusError extends FlatDetailViewEvent {
  final Object error;
  FlatDetailEventChangeItemStatusError(this.error);
}


class FlatDetailViewModel extends ViewEventEmitter<FlatDetailViewEvent> {
  FlatModel flat;

  late final FlatDetailFacade facade =
  FlatDetailFacade(
    flatApi: FlatApiFactory.create(),
    groupApi: GroupApiFactory.create(),
    itemApi: ItemApiFactory.create(),
  );

  FlatDetailState state = FlatDetailLoading();

  FlatDetailViewModel({required this.flat});

  void load() async {
    try {
      _setState(FlatDetailLoading());
      notifyListeners();

      final detail = await facade.requestFlatDetails(flat.id);
      _setState(
          FlatDetailSuccess(model: detail)
      );
    } catch (e) {
      _setState(FlatDetailError(error: e));
    }
  }

  void rotateItemStatus(int groupId, int itemId) async {
    if (this.state is! FlatDetailSuccess) {
      return;
    }

    final state = this.state as FlatDetailSuccess;

    final item = state.model.groups[groupId]?.items[itemId];
    if (item == null) {
      return;
    }

    final prevStatus = item.status;
    final nextStatus = prevStatus.next();
    _modifyItem(
        groupId, itemId,
        (it) => it.copyWith(status: nextStatus)
    );

    try {
      await facade.changeItemStatus(flat.id, groupId, itemId, nextStatus);
    } catch (e) {
      _modifyItem(groupId, itemId, (it) => it.copyWith(status: prevStatus));
      emitEvent(FlatDetailEventChangeItemStatusError(e));
    }
  }

  void _modifyItem(
      int groupId,
      int itemId,
      ItemWithStatus Function(ItemWithStatus) modifier
  ) {
    if (this.state is! FlatDetailSuccess) {
      return;
    }

    final state = this.state as FlatDetailSuccess;

    final newModel = state.model.copyWith(
        groups: state.model.groups.modify(
            groupId,
                (group) => group.copyWith(
                items: group.items.modify(itemId, modifier)
            )
        )
    );

    _setState(state.copyWith(model: newModel));
  }

  void _setState(FlatDetailState newState) {
    state = newState;
    notifyListeners();
  }
}
