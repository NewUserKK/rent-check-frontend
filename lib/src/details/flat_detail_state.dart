import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:rent_checklist/src/common/utils/extensions.dart';
import 'package:rent_checklist/src/details/flat_detail_facade.dart';
import 'package:rent_checklist/src/details/flat_detail_model.dart';
import 'package:rent_checklist/src/details/group/group_api.dart';
import 'package:rent_checklist/src/flat/flat_api.dart';
import 'package:rent_checklist/src/flat/flat_model.dart';

part 'generated/flat_detail_state.freezed.dart';

sealed class FlatDetailState {}

class FlatDetailLoading extends FlatDetailState {}

@freezed
class FlatDetailError extends FlatDetailState with _$FlatDetailError {
  const factory FlatDetailError({
    required Object error
  }) = _FlatDetailError;
}

@freezed
class FlatDetailSuccess extends FlatDetailState with _$FlatDetailSuccess {
  const factory FlatDetailSuccess({
    required FlatDetailModel model
  }) = _FlatDetailSuccess;
}

class FlatDetailViewModel extends ChangeNotifier {
  FlatModel flat;

  late final FlatDetailFacade facade =
      FlatDetailFacade(
          flatApi: FlatApiFactory.create(),
          groupApi: GroupApiFactory.create()
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

  void rotateItemStatus(int groupId, int itemId) {
    if (this.state is! FlatDetailSuccess) {
      return;
    }

    final state = this.state as FlatDetailSuccess;

    final newModel = state.model.copyWith(
      groups: state.model.groups.modify(
          groupId,
          (group) => group.copyWith(
              items: group.items.modify(itemId, (item) => item.copyWith(
                  status: item.status.next()
              ))
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
