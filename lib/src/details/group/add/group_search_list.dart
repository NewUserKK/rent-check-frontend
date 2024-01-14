import 'package:flutter/material.dart';
import 'package:rent_checklist/src/common/arch/view_model_widget_state.dart';
import 'package:rent_checklist/src/common/widgets/load_utils.dart';
import 'package:rent_checklist/src/common/widgets/loader.dart';
import 'package:rent_checklist/src/details/group/add/group_search_list_state.dart';
import 'package:rent_checklist/src/details/group/add/group_search_list_view_model.dart';

class GroupSearchList extends StatefulWidget {
  const GroupSearchList({super.key});

  @override
  State<StatefulWidget> createState() => _GroupSearchListState();
}

class _GroupSearchListState extends ViewModelWidgetState<
    GroupSearchList,
    GroupSearchListState,
    GroupSearchListViewEvent,
    GroupSearchListViewModel
> {
  @override
  void initState() {
    super.initState();
    withProviderOnFrame<GroupSearchListViewModel>(context, (it) => it.load());
  }

  @override
  void handleEvent(GroupSearchListViewEvent event) {}

  @override
  Widget render(GroupSearchListState state) => switch (state) {
    GroupSearchListLoading _ => const Loader(),
    GroupSearchListError err => Text('$err'),
    GroupSearchListLoaded _ => _buildList(state)
  };

  Widget _buildList(GroupSearchListLoaded state) {
    final sliverList = SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final group = state.groups[index];
            return ListTile(
              title: Text(group.title),
            );
          },
          childCount: state.groups.length,
        )
    );

    return Expanded(
        child: CustomScrollView(
          slivers: [sliverList],
        )
    );
  }
}
