import 'package:flutter/material.dart';
import 'package:frontend/screens/categories_and_products_screen.dart';
import 'package:frontend/screens/dashboard_screen.dart';
import 'package:frontend/screens/groups_and_users_screen.dart';
import 'package:frontend/screens/login_screen.dart';
import 'package:frontend/screens/register_screen.dart';
import 'package:frontend/screens/shopping_list_screen.dart';

class ShoppingListApp extends StatelessWidget {
  const ShoppingListApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shopping List',
      debugShowCheckedModeBanner: false,
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/dashboard': (context) => const DashboardScreen(),
        '/shopping_lists': (context) => const ShoppingListScreen(),
        '/groups_and_users': (context) => const GroupsAndUsersScreen(),
        '/categories_and_products': (context) =>
            const CategoriesAndProductsScreen(),
      },
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.green),
    );
  }
}
