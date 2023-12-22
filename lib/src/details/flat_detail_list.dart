import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rent_checklist/src/common/widgets/load_utils.dart';
import 'package:rent_checklist/src/common/widgets/loader.dart';
import 'package:rent_checklist/src/common/widgets/snackbar.dart';
import 'package:rent_checklist/src/details/flat_detail_model.dart';
import 'package:rent_checklist/src/details/flat_detail_state.dart';
import 'package:rent_checklist/src/details/flat_detail_view_model.dart';
import 'package:rent_checklist/src/flat/flat_model.dart';
import 'package:rent_checklist/src/details/group/group_widget.dart';

class FlatDetailList extends StatefulWidget {
  final FlatModel flat;

  const FlatDetailList({super.key, required this.flat});

  @override
  State<StatefulWidget> createState() => _FlatDetailListState();
}

class _FlatDetailListState extends State<FlatDetailList> {
  @override
  void initState() {
    super.initState();
    withProvider<FlatDetailViewModel>(context, (it) => it.load());
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<FlatDetailViewModel>(
      builder: (context, model, _) {
        if (model.currentEvent != null) {
          doOnPostFrame(context, () => _handleEvent(model.currentEvent!));
        }
        return _render(model.state);
      }
    );
  }

  void _handleEvent(FlatDetailViewEvent event) => switch (event) {
    FlatDetailEventChangeItemStatusError e =>
        showSnackBar(context, 'Error updating status: ${e.error}')
  };

  Widget _render(FlatDetailState state) => switch (state) {
    FlatDetailLoading _ => const Loader(),
    FlatDetailError err => Text('$err'),
    FlatDetailSuccess _ => _buildList(state.model)
  };

  Widget _buildList(FlatDetailModel state) {
    return ListView.builder(
      itemCount: state.groups.length,
      itemBuilder: (context, index) {
        final groupDetails = state.groups.values.elementAt(index);
        return GroupWidget(groupDetails: groupDetails);
      },
    );
  }
}
