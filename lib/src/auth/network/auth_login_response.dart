import 'package:freezed_annotation/freezed_annotation.dart';

part 'generated/auth_login_response.freezed.dart';
part 'generated/auth_login_response.g.dart';

@freezed
class AuthLoginResponse with _$AuthLoginResponse {
  const factory AuthLoginResponse({
    required String token,
  }) = _AuthLoginResponse;

  factory AuthLoginResponse.fromJson(
      Map<String, dynamic> json
  ) => _$AuthLoginResponseFromJson(json);
}
