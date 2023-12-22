import 'package:freezed_annotation/freezed_annotation.dart';

part 'generated/group_model.freezed.dart';
part 'generated/group_model.g.dart';

@freezed
class GroupModel with _$GroupModel {
  const factory GroupModel({
    required String title,
    required int id,
  }) = _GroupModel;

  factory GroupModel.fromJson(Map<String, dynamic> json) =>
      _$GroupModelFromJson(json);
}
