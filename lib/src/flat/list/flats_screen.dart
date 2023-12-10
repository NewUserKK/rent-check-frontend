import 'package:flutter/material.dart';
import 'package:rent_checklist/src/common/widgets/app_bar.dart';
import 'package:rent_checklist/src/flat/list/flat_list.dart';
import 'package:rent_checklist/src/res/strings.dart';

class FlatsScreen extends StatelessWidget {
  const FlatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: RentAppBar(
        title: Strings.flatsToolbarTitle,
      ),
      body: const FlatList(),
      floatingActionButton: const FloatingActionButton(
        onPressed: null,
        child: Icon(Icons.add),
      ),
    );
  }
}
