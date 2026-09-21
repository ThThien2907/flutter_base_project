abstract class AuthEvent {
  const AuthEvent();
}

class LoginEvent extends AuthEvent {
  const LoginEvent({
    required this.username,
    required this.password,
    required this.deviceId,
  });

  final String username;
  final String password;
  final String deviceId;
}

class FetchUserDataEvent extends AuthEvent {
  const FetchUserDataEvent();
}

class LogoutEvent extends AuthEvent {
  const LogoutEvent();
}

class ResetAuthEvent extends AuthEvent {
  const ResetAuthEvent();
}
