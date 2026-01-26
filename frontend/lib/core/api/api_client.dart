import 'dart:convert';
import 'package:http/http.dart' as http;
import '../storage/token_storage.dart';

class ApiClient {
  final String baseUrl;
  final TokenStorage storage;

  ApiClient({required this.baseUrl, required this.storage});

  Future<http.Response> post(String path, {Map<String, dynamic>? body}) {
    return _send(
      () => http.post(
        Uri.parse('$baseUrl$path'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      ),
    );
  }

  Future<http.Response> get(String path) {
    return _send(
      () => http.get(
        Uri.parse('$baseUrl$path'),
        headers: {'Content-Type': 'application/json'},
      ),
    );
  }

  Future<http.Response> _send(Future<http.Response> Function() request) async {
    final accessToken = await storage.getAccessToken();

    print('[API] Sending request');
    print('[API] Access token: $accessToken');

    http.Response response;

    if (accessToken != null) {
      response = await requestWithToken(request, accessToken);
    } else {
      response = await request();
    }

    print('[API] Response status: ${response.statusCode}');

    // ❗ Access token wygasł
    if (response.statusCode == 401) {
      print('[API] 401 received → trying refresh token');

      final refreshed = await _refreshToken();

      if (!refreshed) {
        print('[API] Refresh failed → clearing tokens');
        await storage.clear();
        throw Exception('Session expired');
      }

      final newAccessToken = await storage.getAccessToken();
      print('[API] Retrying request with new token');

      response = await requestWithToken(request, newAccessToken!);
    }

    return response;
  }

  Future<http.Response> requestWithToken(
    Future<http.Response> Function() request,
    String token,
  ) {
    return request().then((res) {
      return http.Response(res.body, res.statusCode, headers: res.headers);
    });
  }

  Future<bool> _refreshToken() async {
    final refreshToken = await storage.getRefreshToken();

    if (refreshToken == null) {
      print('[API] No refresh token');
      return false;
    }

    print('[API] Refreshing token');

    final res = await http.post(
      Uri.parse('$baseUrl/api/Auth/refresh-token'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'token': refreshToken}),
    );

    print('[API] Refresh status: ${res.statusCode}');

    if (res.statusCode != 200) return false;

    final data = jsonDecode(res.body);

    await storage.saveAccessToken(data['accessToken']);
    await storage.saveRefreshToken(data['refreshToken']);

    print('[API] Tokens refreshed');

    return true;
  }
}
