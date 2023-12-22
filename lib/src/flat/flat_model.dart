import 'package:freezed_annotation/freezed_annotation.dart';

part 'generated/flat_model.freezed.dart';
part 'generated/flat_model.g.dart';

@freezed
class FlatModel with _$FlatModel {
  const factory FlatModel({
    required String address,
    String? title,
    String? description,
    @Default(0) int id,
  }) = _FlatModel;

  factory FlatModel.fromJson(Map<String, dynamic> json) =>
      _$FlatModelFromJson(json);
}
