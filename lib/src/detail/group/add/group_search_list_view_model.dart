import 'package:rent_checklist/src/common/arch/view_model.dart';
import 'package:rent_checklist/src/detail/group/add/group_search_list_state.dart';
import 'package:rent_checklist/src/detail/group/group_api.dart';

sealed class GroupSearchListViewEvent {}

class GroupSearchListViewModel extends ViewModel<
    GroupSearchListState,
    GroupSearchListViewEvent
> {
  final GroupApi _groupApi = GroupApiFactory.create();

  @override
  GroupSearchListState state = GroupSearchListLoading();

  void load() async {
    try {
      setState(GroupSearchListLoading());

      final groups = await _groupApi.getGroups();
      setState(GroupSearchListLoaded(groups: groups));
    } catch (e) {
      setState(GroupSearchListError(error: e));
    }
  }
}
