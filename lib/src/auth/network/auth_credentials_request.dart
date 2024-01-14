import 'package:freezed_annotation/freezed_annotation.dart';

part 'generated/auth_credentials_request.freezed.dart';
part 'generated/auth_credentials_request.g.dart';

@freezed
class AuthCredentialsRequest with _$AuthCredentialsRequest {
  const factory AuthCredentialsRequest({
    required String login,
    required String password,
  }) = _AuthCredentialsRequest;

  factory AuthCredentialsRequest.fromJson(
      Map<String, dynamic> json
  ) => _$AuthCredentialsRequestFromJson(json);
}
