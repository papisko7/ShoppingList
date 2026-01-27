import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:frontend/core/storage/token_storage.dart';

class ApiClient {
  final String baseUrl;
  final TokenStorage storage;

  ApiClient({required this.baseUrl, required this.storage});

  Future<http.Response> get(String path) async {
    return _sendWithAuth(
      () async =>
          http.get(Uri.parse('$baseUrl$path'), headers: await _headers()),
    );
  }

  Future<http.Response> post(String path, {Object? body}) async {
    return _sendWithAuth(
      () async => http.post(
        Uri.parse('$baseUrl$path'),
        headers: await _headers(),
        body: body != null ? jsonEncode(body) : null,
      ),
    );
  }

  Future<http.Response> put(String path, {Object? body}) async {
    return _sendWithAuth(
      () async => http.put(
        Uri.parse('$baseUrl$path'),
        headers: await _headers(),
        body: body != null ? jsonEncode(body) : null,
      ),
    );
  }

  Future<http.Response> delete(String path) async {
    return _sendWithAuth(
      () async =>
          http.delete(Uri.parse('$baseUrl$path'), headers: await _headers()),
    );
  }

  // =========================
  // INTERNALS
  // =========================

  Future<Map<String, String>> _headers() async {
    final accessToken = await storage.getAccessToken();

    print('[API] Access token: $accessToken');

    return {
      'Content-Type': 'application/json',
      if (accessToken != null) 'Authorization': 'Bearer $accessToken',
    };
  }

  Future<http.Response> _sendWithAuth(
    Future<http.Response> Function() request,
  ) async {
    print('[API] Sending request');

    http.Response response = await request();

    print('[API] Response status: ${response.statusCode}');

    // ⛔ ACCESS TOKEN WYGASŁ
    if (response.statusCode == 401) {
      print('[API] 401 → trying refresh token');

      final refreshed = await _refreshToken();

      if (!refreshed) {
        print('[API] Refresh failed');
        throw Exception('Unauthorized');
      }

      print('[API] Retry original request');
      response = await request();
    }

    return response;
  }

  Future<bool> _refreshToken() async {
    final refreshToken = await storage.getRefreshToken();
    if (refreshToken == null) return false;

    final response = await http.post(
      Uri.parse('$baseUrl/api/Auth/refresh-token'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'token': refreshToken}),
    );

    if (response.statusCode != 200) {
      return false;
    }

    final data = jsonDecode(response.body);

    await storage.saveTokens(
      accessToken: data['accessToken'],
      refreshToken: data['refreshToken'],
    );

    print('[API] Token refreshed');
    return true;
  }
}
