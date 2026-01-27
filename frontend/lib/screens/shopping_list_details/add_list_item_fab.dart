import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:frontend/providers/shopping_list_details_provider.dart';

class AddListItemFab extends StatelessWidget {
  final int listId;

  const AddListItemFab({super.key, required this.listId});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () => _openDialog(context),
      child: const Icon(Icons.add),
    );
  }

  Future<void> _openDialog(BuildContext context) async {
    final nameCtrl = TextEditingController();
    final qtyCtrl = TextEditingController(text: '1');
    final categoryCtrl = TextEditingController();

    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Dodaj produkt'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameCtrl,
              decoration: const InputDecoration(labelText: 'Produkt'),
              autofocus: true,
            ),
            const SizedBox(height: 8),
            TextField(
              controller: qtyCtrl,
              decoration: const InputDecoration(labelText: 'Ilość'),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: categoryCtrl,
              decoration: const InputDecoration(
                labelText: 'Kategoria (opcjonalnie)',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Anuluj'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Dodaj'),
          ),
        ],
      ),
    );

    if (ok != true) return;

    final name = nameCtrl.text.trim();
    final qty = qtyCtrl.text.trim();

    if (name.isEmpty || qty.isEmpty) return;

    await context.read<ShoppingListDetailsProvider>().addItem(
      listId: listId,
      productName: name,
      quantity: qty,
      categoryName: categoryCtrl.text.trim().isEmpty
          ? null
          : categoryCtrl.text.trim(),
    );
  }
}
