import 'package:flutter/material.dart';
import 'package:frontend/providers/categories_provider.dart';
import 'package:provider/provider.dart';

import 'category_tile.dart';
import 'create_category_button.dart';

class CategoriesPanel extends StatelessWidget {
  const CategoriesPanel({super.key});

  @override
  Widget build(BuildContext context) {
    final prov = context.watch<CategoriesProvider>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: const [
            Expanded(
              child: Text(
                'Kategorie',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            CreateCategoryButton(),
          ],
        ),
        const SizedBox(height: 16),

        Expanded(child: _buildList(prov)),
      ],
    );
  }

  Widget _buildList(CategoriesProvider prov) {
    if (prov.isLoading) return const Center(child: CircularProgressIndicator());
    if (prov.error != null)
      return Center(
        child: Text(prov.error!, style: const TextStyle(color: Colors.red)),
      );
    if (prov.categories.isEmpty)
      return const Center(child: Text('Brak kategorii'));

    return ListView.separated(
      itemCount: prov.categories.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (_, i) => CategoryTile(category: prov.categories[i]),
    );
  }
}
