import 'package:freezed_annotation/freezed_annotation.dart';

part 'generated/item_model.freezed.dart';
part 'generated/item_model.g.dart';

@freezed
class ItemModel with _$ItemModel {
  const factory ItemModel({
    required String title,
    String? description,
    required int id,
  }) = _ItemModel;

  factory ItemModel.fromJson(Map<String, dynamic> json) =>
      _$ItemModelFromJson(json);
}


enum ItemStatus {
  unset(value: 'unset'),
  ok(value: 'ok'),
  notOk(value: 'not-ok'),
  meh(value: 'meh');

  final String value;

  const ItemStatus({required this.value});

  factory ItemStatus.fromJson(String json) {
    return ItemStatus.values.firstWhere((it) => it.value == json);
  }

  ItemStatus next() {
    return ItemStatus.values[(index + 1) % ItemStatus.values.length];
  }
}


@freezed
class ItemWithStatus with _$ItemWithStatus {
  const factory ItemWithStatus({
    required ItemModel item,
    required ItemStatus status,
  }) = _ItemWithStatus;

  factory ItemWithStatus.fromJson(Map<String, dynamic> json) =>
      _$ItemWithStatusFromJson(json);
}
