class ItemModel {
  final String title;
  final String? description;
  final int id;

  ItemModel({
    required this.title,
    this.description,
    required this.id,
  });

  factory ItemModel.fromJson(Map<String, dynamic> json) {
    return ItemModel(
      title: json['title'],
      description: json['description'],
      id: json['id'],
    );
  }
}


enum ItemStatus {
  ok(value: 'ok'),
  meh(value: 'meh'),
  notOk(value: 'not-ok');

  final String value;

  const ItemStatus({required this.value});

  factory ItemStatus.fromJson(String json) {
    return ItemStatus.values.firstWhere((it) => it.value == json);
  }
}


class ItemWithStatus {
  final ItemModel item;
  final ItemStatus status;

  ItemWithStatus({required this.item, required this.status});
}
