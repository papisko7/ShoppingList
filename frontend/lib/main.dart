import 'package:flutter/material.dart';
import 'package:frontend/core/api/api_client.dart';
import 'package:frontend/core/storage/web_token_storage.dart';
import 'package:frontend/services/auth_provider.dart';
import 'package:frontend/services/auth_service.dart';
import 'app.dart';
import 'package:provider/provider.dart';

void main() {
  final tokenStorage = WebTokenStorage();
  final apiClient = ApiClient(
    baseUrl: 'http://localhost:5194',
    storage: tokenStorage,
  );

  final authService = AuthService(api: apiClient, storage: tokenStorage);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthProvider(authService: authService),
        ),
      ],
      child: const ShoppingListApp(),
    ),
  );
}
