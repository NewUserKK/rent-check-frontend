import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:rent_checklist/src/details/group/add/group_form.dart';
import 'package:rent_checklist/src/details/group/add/group_search_list.dart';
import 'package:rent_checklist/src/details/group/add/group_search_list_view_model.dart';

class GroupAddScreen extends StatelessWidget {
  const GroupAddScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
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
    );
  }
}
