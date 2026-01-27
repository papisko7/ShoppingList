import 'package:flutter/material.dart';
import 'package:frontend/providers/categories_provider.dart';
import 'package:provider/provider.dart';

class CreateCategoryButton extends StatelessWidget {
  const CreateCategoryButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () => _open(context),
      icon: const Icon(Icons.add),
      label: const Text('Dodaj'),
    );
  }

  Future<void> _open(BuildContext context) async {
    final controller = TextEditingController();

    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Nowa kategoria'),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(labelText: 'Nazwa kategorii'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Anuluj'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Utwórz'),
          ),
        ],
      ),
    );

    if (ok != true) return;

    final name = controller.text.trim();
    if (name.isEmpty) return;

    await context.read<CategoriesProvider>().create(name);
  }
}
