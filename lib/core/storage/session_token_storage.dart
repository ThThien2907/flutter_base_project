abstract class SessionTokenStorage {
  int get sessionGeneration;
  int invalidateSession();
  Future<int> startNewSession({
    required String accessToken,
    required String refreshToken,
  });
  Future<void> updateSessionTokens({
    required String accessToken,
    String? refreshToken,
    required int expectedGeneration,
  });
  Future<void> saveAccessToken(
    String accessToken, {
    int? expectedGeneration,
  });
  Future<void> saveRefreshToken(
    String refreshToken, {
    int? expectedGeneration,
  });
  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
    int? expectedGeneration,
  });
  Future<String?> getAccessToken();
  Future<String?> getRefreshToken();
  Future<bool> hasAccessToken();
  Future<void> clearTokens();
}
