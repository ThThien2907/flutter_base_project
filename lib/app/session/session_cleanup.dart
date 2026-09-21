enum SessionEndReason {
  logout,
  tokenExpired,
}

abstract interface class SessionCleanable {
  Future<void> onSessionClean(SessionEndReason reason) async {
    await onSessionExpired();
  }

  Future<void> onSessionExpired() async {}
}
