import 'package:rent_checklist/src/common/utils/extensions.dart';

class GroupModel {
  String title;
  int id;

  GroupModel({
    required this.title,
    required this.id,
  });

  factory GroupModel.fromJson(Map<String, dynamic> json) => GroupModel(
        title: json['title'],
        id: json['id'],
      );

  Map<String, dynamic> toJson() => {
        'title': title,
        'id': id.takeIf((it) => it > 0),
      }.removeNulls();
}
