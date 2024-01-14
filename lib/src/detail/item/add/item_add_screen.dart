import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:rent_checklist/src/auth/auth_aware_widget.dart';
import 'package:rent_checklist/src/detail/item/add/item_form.dart';
import 'package:rent_checklist/src/detail/item/add/item_search_list.dart';
import 'package:rent_checklist/src/detail/item/add/item_search_list_view_model.dart';

class ItemAddScreen extends StatelessWidget {
  final int groupId;

  const ItemAddScreen({super.key, required this.groupId});

  @override
  Widget build(BuildContext context) {
    return AuthAwareWidget(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ItemForm(groupId: groupId),
            ChangeNotifierProvider(
              create: (context) => ItemSearchListViewModel(),
              child: ItemSearchList(groupId: groupId),
            )
          ],
        ),
      )
    );
  }
}
