import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rent_checklist/src/detail/flat_detail_view_model.dart';
import 'package:rent_checklist/src/detail/group/group_model.dart';
import 'package:rent_checklist/src/detail/item/item_model.dart';

class ItemWidget extends StatelessWidget {
  final GroupModel group;
  final ItemWithStatus item;

  const ItemWidget({super.key, required this.group, required this.item});

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(item.item.id.toString()),
      dismissThresholds: const {
        DismissDirection.horizontal: 0.7
      },
      onDismissed: (direction) => _onItemDelete(context),
      child: InkWell(
        onTap: () => _changeStatus(context),
        child: Padding(
            padding: const EdgeInsets.symmetric(
                vertical: 16.0,
                horizontal: 8.0,
            ),
            child: Row(
              children: [
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    border: Border.all(width: 1.0),
                    borderRadius: const BorderRadius.all(Radius.circular(8.0)),
                    color: _getItemColor(),
                  ),
                ),
                const SizedBox(
                  width: 12.0, height: 0,
                ),
                Text(
                  item.item.title,
                  style: Theme.of(context).textTheme.bodyLarge,
                )
              ],
            )
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

  void _onItemDelete(BuildContext context) {
    Provider.of<FlatDetailViewModel>(context, listen: false).deleteItemFromGroup(
      groupId: group.id,
      itemId: item.item.id,
    );
  }

  Color _getItemColor() => switch (item.status) {
    ItemStatus.unset => Colors.black12,
    ItemStatus.ok => Colors.green.shade100,
    ItemStatus.meh => Colors.yellow.shade100,
    ItemStatus.notOk => Colors.red.shade100,
  };
}
