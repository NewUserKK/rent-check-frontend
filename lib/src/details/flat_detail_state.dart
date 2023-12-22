import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:rent_checklist/src/details/flat_detail_model.dart';

part 'generated/flat_detail_state.freezed.dart';

sealed class FlatDetailState {}

class FlatDetailLoading extends FlatDetailState {}

@freezed
class FlatDetailError extends FlatDetailState with _$FlatDetailError {
  const factory FlatDetailError({
    required Object error
  }) = _FlatDetailError;
}

@freezed
class FlatDetailSuccess extends FlatDetailState with _$FlatDetailSuccess {
  const factory FlatDetailSuccess({
    required FlatDetailModel model
  }) = _FlatDetailSuccess;
}
