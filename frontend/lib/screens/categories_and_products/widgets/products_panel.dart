import 'package:flutter/material.dart';
import 'package:frontend/providers/products_provider.dart';
import 'package:provider/provider.dart';

import 'product_tile.dart';
import 'create_product_button.dart';

class ProductsPanel extends StatelessWidget {
  const ProductsPanel({super.key});

  @override
  Widget build(BuildContext context) {
    final prov = context.watch<ProductsProvider>();

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

        Expanded(child: _buildList(prov)),
      ],
    );
  }

  Widget _buildList(ProductsProvider prov) {
    if (prov.isLoading) return const Center(child: CircularProgressIndicator());
    if (prov.error != null)
      return Center(
        child: Text(prov.error!, style: const TextStyle(color: Colors.red)),
      );
    if (prov.products.isEmpty)
      return const Center(child: Text('Brak produktów'));

    return ListView.separated(
      itemCount: prov.products.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (_, i) => ProductTile(product: prov.products[i]),
    );
  }
}
