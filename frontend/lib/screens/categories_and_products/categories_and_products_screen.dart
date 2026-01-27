import 'package:flutter/material.dart';
import 'package:frontend/ui/sidebar/sidebar_layout.dart';
import 'package:frontend/ui/top_app_bar/top_app_bar.dart';
import 'package:frontend/providers/categories_provider.dart';
import 'package:frontend/providers/products_provider.dart';
import 'package:provider/provider.dart';

import 'widgets/categories_panel.dart';
import 'widgets/products_panel.dart';

class CategoriesAndProductsScreen extends StatefulWidget {
  const CategoriesAndProductsScreen({super.key});

  @override
  State<CategoriesAndProductsScreen> createState() =>
      _CategoriesAndProductsScreenState();
}

class _CategoriesAndProductsScreenState
    extends State<CategoriesAndProductsScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<CategoriesProvider>().fetch();
      context.read<ProductsProvider>().fetch();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TopAppBar(
        onLogout: () => Navigator.pushReplacementNamed(context, '/login'),
      ),
      body: SidebarLayout(
        active: "categories",
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Row(
            children: const [
              Expanded(child: CategoriesPanel()),
              SizedBox(width: 24),
              Expanded(child: ProductsPanel()),
            ],
          ),
        ),
      ),
    );
  }
}
