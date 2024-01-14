import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:rent_checklist/src/detail/group/group_model.dart';

part 'generated/group_search_list_state.freezed.dart';

sealed class GroupSearchListState {}

class GroupSearchListLoading extends GroupSearchListState {}

@freezed
class GroupSearchListError
    extends GroupSearchListState
    with _$GroupSearchListError {

  const factory GroupSearchListError({
    required Object error
  }) = _GroupSearchListError;
}

@freezed
class GroupSearchListLoaded
    extends GroupSearchListState
    with _$GroupSearchListLoaded {

  const factory GroupSearchListLoaded({
    required List<GroupModel> groups
  }) = _GroupSearchListLoaded;
}
