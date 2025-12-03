import 'package:flutter/material.dart';
import 'package:frontend/ui/sidebar/sidebar_layout.dart';

class CategoriesAndProductsScreen extends StatelessWidget {
  const CategoriesAndProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Categories and Products"),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/login');
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: SidebarLayout(
        active: "categories",
        child: SingleChildScrollView(
          // ← dodane
          padding: const EdgeInsets.all(32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                "Witaj 👋",
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 24),
              Text("Zawartość kategorii i produktow..."),
            ],
          ),
        ),
      ),
    );
  }
}
