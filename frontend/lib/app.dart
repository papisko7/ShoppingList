import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:frontend/providers/auth_provider.dart';
import 'package:frontend/screens/categories_and_products/categories_and_products_screen.dart';
import 'package:frontend/screens/dashboard_screen.dart';
import 'package:frontend/screens/group_and_users/groups_and_users_screen.dart';
import 'package:frontend/screens/login_screen.dart';
import 'package:frontend/screens/register_screen.dart';
import 'package:frontend/screens/shopping_list_screen.dart';

class ShoppingListApp extends StatelessWidget {
  const ShoppingListApp({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    if (auth.loading) {
      return const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(body: Center(child: CircularProgressIndicator())),
      );
    }

    return MaterialApp(
      title: 'Shopping List',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.green),

      home: auth.isAuthenticated
          ? const DashboardScreen()
          : const LoginScreen(),

      routes: {
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),

        '/dashboard': (context) => const DashboardScreen(),
        '/shopping_lists': (context) => const ShoppingListScreen(),
        '/groups_and_users': (context) => const GroupsAndUsersScreen(),
        '/categories_and_products': (context) =>
            const CategoriesAndProductsScreen(),
      },
    );
  }
}
