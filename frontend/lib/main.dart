import 'package:flutter/material.dart';
import 'package:frontend/providers/categories_provider.dart';
import 'package:frontend/providers/categories_selection_provider.dart';
import 'package:frontend/providers/products_provider.dart';
import 'package:frontend/services/category_service.dart';
import 'package:frontend/services/product_service.dart';
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
  final categoryService = CategoryService(apiClient);
  final productService = ProductService(apiClient);

  runApp(
    MultiProvider(
      providers: [
        Provider<ApiClient>.value(value: apiClient),

        ChangeNotifierProvider(
          create: (_) => AuthProvider(authService: authService)..init(),
        ),

        ChangeNotifierProvider(
          create: (_) => GroupsProvider(service: groupService),
        ),
        ChangeNotifierProvider(
          create: (_) => CategoriesProvider(service: categoryService)..fetch(),
        ),
        ChangeNotifierProvider(create: (_) => CategoriesSelectionProvider()),
        ChangeNotifierProvider(
          create: (_) => ProductsProvider(service: productService)..fetch(),
        ),
      ],
      child: const ShoppingListApp(),
    ),
  );
}
