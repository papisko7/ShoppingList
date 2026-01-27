import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'app.dart';

import 'package:frontend/core/api/api_client.dart';
import 'package:frontend/core/storage/web_token_storage.dart';

import 'package:frontend/services/auth_service.dart';
import 'package:frontend/services/group_service.dart';

import 'package:frontend/providers/auth_provider.dart';
import 'package:frontend/providers/groups_provider.dart';

void main() {
  final tokenStorage = WebTokenStorage();

  final apiClient = ApiClient(
    baseUrl: 'http://localhost:5194',
    storage: tokenStorage,
  );

  final authService = AuthService(api: apiClient, storage: tokenStorage);

  final groupService = GroupService(apiClient);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthProvider(authService: authService)..init(),
        ),

        ChangeNotifierProvider(
          create: (_) => GroupsProvider(service: groupService),
        ),
      ],
      child: const ShoppingListApp(),
    ),
  );
}
