import 'package:flutter/material.dart';
import 'package:frontend/providers/categories_provider.dart';
import 'package:frontend/providers/products_provider.dart';
import 'package:provider/provider.dart';

class CreateProductButton extends StatelessWidget {
  const CreateProductButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () => _open(context),
      icon: const Icon(Icons.add),
      label: const Text('Dodaj'),
    );
  }

  Future<void> _open(BuildContext context) async {
    final categories = context.read<CategoriesProvider>().categories;
    if (categories.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Najpierw dodaj kategorię')));
      return;
    }

    final nameCtrl = TextEditingController();
    int selectedId = categories.first.id;

    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (ctx, setState) => AlertDialog(
          title: const Text('Nowy produkt'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameCtrl,
                autofocus: true,
                decoration: const InputDecoration(labelText: 'Nazwa produktu'),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<int>(
                value: selectedId,
                items: categories
                    .map(
                      (c) => DropdownMenuItem(value: c.id, child: Text(c.name)),
                    )
                    .toList(),
                onChanged: (v) => setState(() => selectedId = v ?? selectedId),
                decoration: const InputDecoration(labelText: 'Kategoria'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Anuluj'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text('Utwórz'),
            ),
          ],
        ),
      ),
    );

    if (ok != true) return;

    final name = nameCtrl.text.trim();
    if (name.isEmpty) return;

    final categoryName = categories.firstWhere((c) => c.id == selectedId).name;

    await context.read<ProductsProvider>().create(
      productName: name,
      categoryId: selectedId,
      categoryName: categoryName,
    );
  }
}
