import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rent_checklist/src/common/widgets/app_bar.dart';
import 'package:rent_checklist/src/details/flat_detail_list.dart';
import 'package:rent_checklist/src/details/flat_detail_state.dart';
import 'package:rent_checklist/src/details/flat_detail_view_model.dart';
import 'package:rent_checklist/src/details/group/group_form.dart';
import 'package:rent_checklist/src/flat/flat_model.dart';

class FlatDetailScreen extends StatelessWidget {
  final FlatModel flat;
  final FlatDetailViewModel _viewModel;

  FlatDetailScreen({super.key, required this.flat}) :
        _viewModel = FlatDetailViewModel(flat: flat);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _viewModel,
      child: Scaffold(
        appBar: RentAppBar(title: flat.address),
        body: FlatDetailList(flat: flat),
        floatingActionButton: Consumer<FlatDetailViewModel>(
          builder: (context, model, _) => model.state is FlatDetailSuccess
              ? _renderAddGroupButton(context)
              : const Stack(),
        ),
      ),
    );
  }

  Widget _renderAddGroupButton(BuildContext context) => FloatingActionButton(
    onPressed: () => _onAddGroupPressed(context),
    child: const Icon(Icons.add),
  );

  void _onAddGroupPressed(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => ChangeNotifierProvider.value(
        value: _viewModel,
        child: const Padding(
          padding: EdgeInsets.all(16.0),
          child: GroupForm(),
        )
      )
    );
  }
}
