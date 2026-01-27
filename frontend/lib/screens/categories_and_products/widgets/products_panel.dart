import 'package:flutter/material.dart';
import 'package:frontend/providers/products_provider.dart';
import 'package:frontend/providers/categories_selection_provider.dart';
import 'package:provider/provider.dart';

import 'product_tile.dart';
import 'create_product_button.dart';

class ProductsPanel extends StatelessWidget {
  const ProductsPanel({super.key});

  @override
  Widget build(BuildContext context) {
    final prov = context.watch<ProductsProvider>();
    final selectedCategoryId = context
        .watch<CategoriesSelectionProvider>()
        .selectedCategoryId;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: const [
            Expanded(
              child: Text(
                'Produkty',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            CreateProductButton(),
          ],
        ),
        const SizedBox(height: 16),

        Expanded(child: _buildList(prov, selectedCategoryId)),
      ],
    );
  }

  Widget _buildList(ProductsProvider prov, int? selectedCategoryId) {
    if (prov.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (selectedCategoryId == null) {
      return const Center(child: Text('Wybierz kategorię'));
    }

    final products = prov.products
        .where((p) => p.categoryId == selectedCategoryId)
        .toList();

    if (products.isEmpty) {
      return const Center(child: Text('Brak produktów'));
    }

    return ListView.separated(
      itemCount: products.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (_, i) => ProductTile(product: products[i]),
    );
  }
}
