import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rent_checklist/src/details/flat_detail_state.dart';
import 'package:rent_checklist/src/details/group/group_model.dart';
import 'package:rent_checklist/src/details/item/item_model.dart';

class ItemWidget extends StatelessWidget {
  final GroupModel group;
  final ItemWithStatus item;

  const ItemWidget({super.key, required this.group, required this.item});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: _getItemColor(),
      child: InkWell(
        onTap: () => _changeStatus(context),
        child: Padding(
            padding: const EdgeInsets.symmetric(
                vertical: 16.0,
                horizontal: 8.0,
            ),
            child: Text(item.item.title)
        ),
      ),
    );
  }

  void _changeStatus(BuildContext context) {
    Provider.of<FlatDetailViewModel>(context, listen: false).rotateItemStatus(
      group.id,
      item.item.id,
    );
  }

  Color _getItemColor() => switch (item.status) {
    ItemStatus.unset => Colors.black12,
    ItemStatus.ok => Colors.green.shade100,
    ItemStatus.meh => Colors.yellow.shade100,
    ItemStatus.notOk => Colors.red.shade100,
  };
}
