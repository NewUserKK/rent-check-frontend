import 'package:flutter/material.dart';
import 'package:rent_checklist/src/common/arch/view_model_widget_state.dart';
import 'package:rent_checklist/src/common/widgets/load_utils.dart';
import 'package:rent_checklist/src/common/widgets/loader.dart';
import 'package:rent_checklist/src/common/widgets/snackbar.dart';
import 'package:rent_checklist/src/detail/flat_detail_state.dart';
import 'package:rent_checklist/src/detail/flat_detail_view_model.dart';
import 'package:rent_checklist/src/flat/flat_model.dart';
import 'package:rent_checklist/src/detail/group/group_detail_widget.dart';
import 'package:rent_checklist/src/res/strings.dart';

class FlatDetailList extends StatefulWidget {
  final FlatModel flat;

  const FlatDetailList({super.key, required this.flat});

  @override
  State<StatefulWidget> createState() => _FlatDetailListState();
}

class _FlatDetailListState extends ViewModelWidgetState<
    FlatDetailList,
    FlatDetailState,
    FlatDetailViewEvent,
    FlatDetailViewModel
> {

  @override
  void initState() {
    super.initState();
    withProviderOnFrame<FlatDetailViewModel>(context, (it) => it.load());
  }

  @override
  void handleEvent(FlatDetailViewEvent event) => switch (event) {
    FlatDetailEventChangeItemStatusError e =>
        showSnackBar(context, 'Error updating status: ${e.error}')
  };

  @override
  Widget render(FlatDetailState state) => switch (state) {
    FlatDetailLoading _ => const Loader(),
    FlatDetailError err => Text('$err'),
    FlatDetailLoaded _ => _buildList(state)
  };

  Widget _buildList(FlatDetailLoaded state) {
    final groupList = state.model.groups.values.toList();

    if (groupList.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(16.0),
        child: Center(child: Text(Strings.groupListEmptyMessage)),
      );
    }

    return ListView.builder(
      itemCount: state.model.groups.length,
      padding: const EdgeInsets.all(16.0),
      itemBuilder: (context, index) {
        final groupDetails = groupList[index];
        return GroupWidget(groupDetails: groupDetails);
      },
    );
  }
}
