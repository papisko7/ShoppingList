import 'dart:convert';

import 'package:frontend/core/api/api_client.dart';
import 'package:frontend/core/storage/token_storage.dart';

class AuthService {
  final ApiClient api;
  final TokenStorage storage;

  AuthService({required this.api, required this.storage});

  Future<void> login(String username, String password) async {
    final res = await api.post(
      '/api/Auth/login',
      body: {'username': username, 'password': password},
    );

    if (res.statusCode != 200) {
      throw Exception('Login failed');
    }

    final data = jsonDecode(res.body);
    await storage.saveTokens(
      accessToken: data['accessToken'],
      refreshToken: data['refreshToken'],
    );
  }

  Future<void> register(String username, String password) async {
    print('[AUTH SERVICE] Register start');
    print('[AUTH SERVICE] username=$username');
    final res = await api.post(
      '/api/Auth/register',
      body: {'username': username, 'password': password},
    );

    print('[AUTH SERVICE] statusCode=${res.statusCode}');
    print('[AUTH SERVICE] raw body=${res.body}');

    if (res.statusCode == 200) return;

    final body = jsonDecode(res.body);

    if (res.statusCode == 409) {
      throw RegisterException('Użytkownik już istnieje');
    }

    if (res.statusCode == 400 && body['errors'] != null) {
      final errors = body['errors'] as Map<String, dynamic>;

      if (errors.containsKey('Username')) {
        throw RegisterException(errors['Username'][0]);
      }

      if (errors.containsKey('Password')) {
        throw RegisterException(errors['Password'][0]);
      }

      throw RegisterException('Błąd walidacji danych');
    }

    throw RegisterException('Błąd rejestracji');
  }

  Future<void> refreshToken() async {
    final refreshToken = await storage.getRefreshToken();
    if (refreshToken == null) return;

    final res = await api.post(
      '/api/Auth/refresh-token',
      body: {'token': refreshToken},
    );

    if (res.statusCode != 200) {
      await storage.clear();
      throw Exception('Session expired');
    }

    final data = jsonDecode(res.body);
    await storage.saveTokens(
      accessToken: data['accessToken'],
      refreshToken: data['refreshToken'],
    );
  }

  Future<void> logout() async {
    await storage.clear();
  }
}

class RegisterException implements Exception {
  final String message;
  RegisterException(this.message);
}
