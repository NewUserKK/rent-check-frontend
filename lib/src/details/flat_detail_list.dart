import 'package:flutter/material.dart';
import 'package:rent_checklist/src/common/widgets/load_utils.dart';
import 'package:rent_checklist/src/details/flat_detail_facade.dart';
import 'package:rent_checklist/src/details/flat_detail_model.dart';
import 'package:rent_checklist/src/flat/flat_api.dart';
import 'package:rent_checklist/src/flat/flat_model.dart';
import 'package:rent_checklist/src/details/group/group_api.dart';
import 'package:rent_checklist/src/details/group/group_widget.dart';

class FlatDetailList extends StatefulWidget {
  final FlatModel flat;

  const FlatDetailList({super.key, required this.flat});

  @override
  State<StatefulWidget> createState() => _FlatDetailListState();
}

class _FlatDetailListState extends State<FlatDetailList> {
  late Future<FlatDetailModel> state;

  final flatApi = FlatApiFactory.create();
  final groupApi = GroupApiFactory.create();

  late final FlatDetailFacade facade = FlatDetailFacade(
      flatApi: flatApi,
      groupApi: groupApi
  );

  @override
  void initState() {
    super.initState();
    state = facade.requestFlatDetails(widget.flat.id);
  }

  @override
  Widget build(BuildContext context) {
    return renderOnLoad(state, (data) => _buildList(data));
  }

  Widget _buildList(FlatDetailModel state) {
    return ListView.builder(
      itemCount: state.groups.length,
      itemBuilder: (context, index) {
        final groupDetails = state.groups[index];

        return GroupWidget(groupDetails: groupDetails);
      },
    );
  }
}
