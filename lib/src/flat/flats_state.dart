import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:rent_checklist/src/flat/flat_model.dart';

part 'generated/flats_state.freezed.dart';

sealed class FlatsState {}

class FlatsStateLoading extends FlatsState {}

@freezed
class FlatsStateLoaded extends FlatsState with _$FlatsStateLoaded {
  const factory FlatsStateLoaded({
    required Map<int, FlatModel> flats,
  }) = _FlatsStateLoaded;
}

@freezed
class FlatsStateError extends FlatsState with _$FlatsStateError {
  const factory FlatsStateError({
    required Object error,
  }) = _FlatsStateError;
}
