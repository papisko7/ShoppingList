import 'package:web/web.dart' as web;
import 'token_storage.dart';

class WebTokenStorage implements TokenStorage {
  static const _accessTokenKey = 'access_token';
  static const _refreshTokenKey = 'refresh_token';

  web.Storage get _storage => web.window.localStorage;

  @override
  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    await saveAccessToken(accessToken);
    await saveRefreshToken(refreshToken);
  }

  @override
  Future<void> saveAccessToken(String token) async {
    _storage.setItem(_accessTokenKey, token);
  }

  @override
  Future<void> saveRefreshToken(String token) async {
    _storage.setItem(_refreshTokenKey, token);
  }

  @override
  Future<String?> getAccessToken() async {
    return _storage.getItem(_accessTokenKey);
  }

  @override
  Future<String?> getRefreshToken() async {
    return _storage.getItem(_refreshTokenKey);
  }

  @override
  Future<void> clear() async {
    _storage.removeItem(_accessTokenKey);
    _storage.removeItem(_refreshTokenKey);
  }
}
