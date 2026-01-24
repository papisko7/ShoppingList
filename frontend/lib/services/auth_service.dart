import 'dart:convert';

import 'package:frontend/core/api/api_client.dart';
import 'package:frontend/core/storage/token_storage.dart';
import 'package:frontend/models/register_request.dart';

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
    await storage.saveAccessToken(data['accessToken']);
    await storage.saveRefreshToken(data['refreshToken']);
  }

  Future<void> register(String username, String password) async {
    final req = RegisterRequest(username, password);

    final res = await api.post('/api/Auth/register', body: req.toJson());

    if (res.statusCode != 200) {
      throw Exception('Register failed');
    }
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
    await storage.saveAccessToken(data['accessToken']);
    await storage.saveRefreshToken(data['refreshToken']);
  }

  Future<void> logout() async {
    await storage.clear();
  }
}
