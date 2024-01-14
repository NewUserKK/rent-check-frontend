import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rent_checklist/src/detail/flat_detail_model.dart';
import 'package:rent_checklist/src/detail/flat_detail_view_model.dart';
import 'package:rent_checklist/src/detail/item/item_form.dart';
import 'package:rent_checklist/src/detail/item/item_widget.dart';

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
                      IconButton(
                          onPressed: () => _onItemAddClicked(
                              context,
                              groupDetails.group.id
                          ),
                          icon: const Icon(Icons.add)
                      )
                    ],
                  ),
                  SizedBox(height: groupDetails.items.isNotEmpty ? 12.0 : 0),
                  ...groupDetails.items.values.map((it) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: ItemWidget(group: groupDetails.group, item: it)
                  ))
                ]
            ),
      ),
    );
  }

  void _onItemAddClicked(BuildContext context, int groupId) {
    final viewModel = Provider.of<FlatDetailViewModel>(context, listen: false);
    showModalBottomSheet(
        context: context,
        builder: (context) => ChangeNotifierProvider.value(
            value: viewModel,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: ItemForm(groupId: groupId),
            )
        )
    );
  }
}
