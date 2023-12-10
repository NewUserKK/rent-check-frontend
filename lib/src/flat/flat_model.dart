import 'package:rent_checklist/src/common/utils/extensions.dart';

class FlatModel {
  final String address;
  final String? title;
  final String? description;
  final int id;

  FlatModel({
    required this.address,
    this.title,
    this.description,
    this.id = 0,
  });

  factory FlatModel.fromJson(Map<String, dynamic> json) => FlatModel(
        address: json['address'],
        title: json['title'],
        description: json['description'],
        id: json['id'],
      );

  Map<String, dynamic> toJson() => {
        'address': address,
        'title': title.takeIfNotBlank(),
        'description': description.takeIfNotBlank(),
        'id': id.takeIf((it) => it > 0),
      }.removeNulls();

  @override
  String toString() => toJson().toString();
}
