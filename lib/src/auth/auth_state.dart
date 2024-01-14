import 'package:freezed_annotation/freezed_annotation.dart';

part 'generated/auth_state.freezed.dart';

sealed class AuthState {}

@freezed
class Authorized extends AuthState with _$Authorized {
  const factory Authorized({
    required String token
  }) = _Authorized;
}

class NotAuthorized extends AuthState {}
