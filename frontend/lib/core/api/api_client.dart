import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:frontend/core/storage/token_storage.dart';
import 'package:http/http.dart' as http;

class ApiClient {
  final String baseUrl;
  final TokenStorage tokenStorage;

  ApiClient({required this.baseUrl, required this.tokenStorage});

  Future<http.Response> post(
    String path, {
    Map<String, dynamic>? body,
    bool authorized = false,
  }) async {
    final headers = {'Content-Type': 'application/json'};

    if (authorized) {
      final token = await tokenStorage.getAccessToken();
      headers['Authorization'] = 'Bearer $token';
    }

    final url = '$baseUrl$path';

    debugPrint('➡️ POST $url');
    debugPrint('Headers: $headers');
    debugPrint('Body: $body');

    final response = await http.post(
      Uri.parse(url),
      headers: headers,
      body: jsonEncode(body),
    );

    debugPrint('⬅️ RESPONSE ${response.statusCode}');
    debugPrint('Response body: ${response.body}');

    return response;
  }
}
