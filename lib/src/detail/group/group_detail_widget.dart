import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rent_checklist/src/detail/flat_detail_model.dart';
import 'package:rent_checklist/src/detail/flat_detail_view_model.dart';
import 'package:rent_checklist/src/detail/group/group_model.dart';
import 'package:rent_checklist/src/detail/item/add/item_add_screen.dart';
import 'package:rent_checklist/src/detail/item/item_widget.dart';
import 'package:rent_checklist/src/res/strings.dart';

class GroupWidget extends StatelessWidget {
  final FlatDetailGroup groupDetails;

  const GroupWidget({super.key, required this.groupDetails});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child:
            Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        groupDetails.group.title,
                        style: Theme.of(context).textTheme.headlineSmall
                      ),
                      Row(
                        children: [
                          IconButton(
                            onPressed: () => _onDeleteClicked(
                                context,
                                groupDetails.group
                            ),
                            icon: const Icon(Icons.delete),
                          ),
                          IconButton(
                              onPressed: () => _onItemAddClicked(
                                  context,
                                  groupDetails.group.id
                              ),
                              icon: const Icon(Icons.add)
                          ),
                        ],
                      )
                    ],
                  ),
                  SizedBox(height: groupDetails.items.isNotEmpty ? 6.0 : 0),
                  ...groupDetails.items.values.map((it) =>
                      ItemWidget(group: groupDetails.group, item: it))
                ]
            ),
      ),
    );
  }

  void _onItemAddClicked(BuildContext context, int groupId) {
    final viewModel = Provider.of<FlatDetailViewModel>(context, listen: false);
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) => ChangeNotifierProvider.value(
            value: viewModel,
            child: DraggableScrollableSheet(
                maxChildSize: 0.7,
                minChildSize: 0.7,
                initialChildSize: 0.7,
                expand: false,
                builder: (context, _) => Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ItemAddScreen(groupId: groupId),
                )
            )
        )
    );
  }

  void _onDeleteClicked(BuildContext context, GroupModel group) {
    final viewModel = Provider.of<FlatDetailViewModel>(context, listen: false);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Center(child: Text(Strings.groupDeleteDialogTitle)),
        actionsAlignment: MainAxisAlignment.spaceBetween,
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text(Strings.groupDeleteDialogCancel),
          ),
          ElevatedButton(
            onPressed: () {
              viewModel.deleteGroupFromFlat(group);
              Navigator.of(context).pop();
            },
            child: const Text(Strings.groupDeleteDialogConfirm),
          )
        ],
      )
    );
  }
}
