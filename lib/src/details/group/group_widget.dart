import 'package:flutter/material.dart';
import 'package:rent_checklist/src/details/flat_detail_model.dart';
import 'package:rent_checklist/src/details/item/item_widget.dart';

class GroupWidget extends StatelessWidget {
  final FlatDetailGroup groupDetails;

  const GroupWidget({super.key, required this.groupDetails});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                groupDetails.group.title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Column(
                children: groupDetails.items
                    .map((it) => ItemWidget(
                        group: groupDetails.group,
                        item: it
                    ))
                    .toList(),
              )
            ]
        ),
      ),
    );
  }
}