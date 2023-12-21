import 'package:rent_checklist/src/details/group/group_model.dart';
import 'package:rent_checklist/src/details/item/item_model.dart';

class FlatDetailModel {
  final List<FlatDetailGroup> groups;

  FlatDetailModel({required this.groups});
}

class FlatDetailGroup {
  final GroupModel group;
  final List<ItemWithStatus> items;

  FlatDetailGroup({required this.group, required this.items});
}