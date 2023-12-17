import 'package:rent_checklist/src/group/group_model.dart';
import 'package:rent_checklist/src/item/item_model.dart';

class FlatDetailModel {
  final List<FlatDetailGroup> groups;

  FlatDetailModel({required this.groups});
}

class FlatDetailGroup {
  final GroupModel group;
  final List<ItemWithStatus> items;

  FlatDetailGroup({required this.group, required this.items});
}
