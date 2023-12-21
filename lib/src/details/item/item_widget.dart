import 'package:flutter/material.dart';
import 'package:rent_checklist/src/details/group/group_model.dart';
import 'package:rent_checklist/src/details/item/item_model.dart';

class ItemWidget extends StatefulWidget {
  final GroupModel group;
  final ItemWithStatus item;

  const ItemWidget({super.key, required this.group, required this.item});

  @override
  State<StatefulWidget> createState() => _ItemWidgetState();
}

class _ItemWidgetState extends State<ItemWidget> {
  @override
  Widget build(BuildContext context) {
    return Text(widget.item.item.title);
  }
}
