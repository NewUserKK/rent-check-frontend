import 'package:flutter/material.dart';
import 'package:rent_checklist/src/common/widgets/app_bar.dart';
import 'package:rent_checklist/src/flat/add/flat_add_screen.dart';
import 'package:rent_checklist/src/flat/list/flat_list.dart';
import 'package:rent_checklist/src/res/strings.dart';

class FlatsScreen extends StatelessWidget {
  const FlatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: RentAppBar(
        title: Strings.flatListToolbarTitle,
      ),
      body: const FlatList(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToAddFlat(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _navigateToAddFlat(BuildContext context) {
    Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => const FlatAddScreen())
    );
  }
}
