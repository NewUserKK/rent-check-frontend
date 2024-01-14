import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:rent_checklist/src/auth/auth_aware_widget.dart';
import 'package:rent_checklist/src/detail/group/add/group_form.dart';
import 'package:rent_checklist/src/detail/group/add/group_search_list.dart';
import 'package:rent_checklist/src/detail/group/add/group_search_list_view_model.dart';

class GroupAddScreen extends StatelessWidget {
  const GroupAddScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AuthAwareWidget(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const GroupForm(),
            ChangeNotifierProvider(
              create: (context) => GroupSearchListViewModel(),
              child: const GroupSearchList(),
            )
          ],
        ),
      )
    );
  }
}
