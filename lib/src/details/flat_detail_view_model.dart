import 'package:rent_checklist/src/common/arch/view_model.dart';
import 'package:rent_checklist/src/common/utils/extensions.dart';
import 'package:rent_checklist/src/common/widgets/debouncer.dart';
import 'package:rent_checklist/src/details/flat_detail_facade.dart';
import 'package:rent_checklist/src/details/flat_detail_state.dart';
import 'package:rent_checklist/src/details/group/group_api.dart';
import 'package:rent_checklist/src/details/group/group_model.dart';
import 'package:rent_checklist/src/details/item/item_api.dart';
import 'package:rent_checklist/src/details/item/item_model.dart';
import 'package:rent_checklist/src/flat/flat_api.dart';
import 'package:rent_checklist/src/flat/flat_model.dart';

sealed class FlatDetailViewEvent {}
class FlatDetailEventChangeItemStatusError extends FlatDetailViewEvent {
  final Object error;
  FlatDetailEventChangeItemStatusError(this.error);
}


class FlatDetailViewModel extends ViewModel<
    FlatDetailState,
    FlatDetailViewEvent
> {
  FlatModel flat;

  late final FlatDetailFacade _facade = FlatDetailFacade(
    flatApi: FlatApiFactory.create(),
    groupApi: GroupApiFactory.create(),
    itemApi: ItemApiFactory.create(),
  );

  final _itemStatusDebouncer = Debouncer();
  ItemStatus? _previousItemStatus;

  @override
  FlatDetailState state = FlatDetailLoading();

  FlatDetailViewModel({required this.flat});

  void load() async {
    try {
      setState(FlatDetailLoading());

      final detail = await _facade.requestFlatDetails(flat.id);
      setState(FlatDetailLoaded(model: detail));
    } catch (e) {
      setState(FlatDetailError(error: e));
    }
  }

  void rotateItemStatus(int groupId, int itemId) async {
    if (this.state is! FlatDetailLoaded) {
      return;
    }

    final state = this.state as FlatDetailLoaded;

    final item = state.model.groups[groupId]?.items[itemId];
    if (item == null) {
      return;
    }

    final prevStatus = item.status;
    _previousItemStatus ??= prevStatus;
    final nextStatus = prevStatus.next();
    _modifyItem(
        groupId, itemId,
        (it) => it.copyWith(status: nextStatus)
    );

    _itemStatusDebouncer.run(() async {
      try {
        await _facade.changeItemStatus(flat.id, groupId, itemId, nextStatus);
      } catch (e) {
        _modifyItem(
            groupId, itemId,
            (it) => it.copyWith(status: _previousItemStatus!)
        );
        emitEvent(FlatDetailEventChangeItemStatusError(e));
      } finally {
        _previousItemStatus = null;
      }
    });
  }

  Future<void> createAndAddGroup(GroupModel group) async {
    if (this.state is! FlatDetailLoaded) {
      return;
    }

    final state = this.state as FlatDetailLoaded;

    final newGroupDetails = await _facade.createAndAddGroup(flat.id, group);

    setState(state.copyWith(
        model: state.model.copyWith(
            groups: state.model.groups.set(
                newGroupDetails.group.id,
                newGroupDetails
            )
        )
    ));
  }

  Future<void> createAndAddItem(int groupId, ItemModel item) async {
    if (this.state is! FlatDetailLoaded) {
      return;
    }

    final state = this.state as FlatDetailLoaded;

    final newItem = await _facade.createAndAddItem(
        flatId: flat.id,
        groupId: groupId,
        item: item
    );

    final newModel = state.copyWith(
        model: state.model.copyWith(
            groups: state.model.groups.modify(
                groupId,
                (group) => group.copyWith(
                    items: group.items.set(newItem.item.id, newItem)
                )
            )
        )
    );

    setState(newModel);
  }

  void _modifyItem(
      int groupId,
      int itemId,
      ItemWithStatus Function(ItemWithStatus) modifier
  ) {
    if (this.state is! FlatDetailLoaded) {
      return;
    }

    final state = this.state as FlatDetailLoaded;

    final newModel = state.model.copyWith(
        groups: state.model.groups.modify(
            groupId,
            (group) => group.copyWith(
                items: group.items.modify(itemId, modifier)
            )
        )
    );

    setState(state.copyWith(model: newModel));
  }
}
