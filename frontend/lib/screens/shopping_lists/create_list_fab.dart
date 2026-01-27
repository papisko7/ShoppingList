import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:frontend/providers/shopping_lists_provider.dart';

class CreateListFab extends StatelessWidget {
  const CreateListFab({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () => _open(context),
      child: const Icon(Icons.add),
    );
  }

  Future<void> _open(BuildContext context) async {
    final ctrl = TextEditingController();

    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Nowa lista'),
        content: TextField(
          controller: ctrl,
          autofocus: true,
          decoration: const InputDecoration(labelText: 'Nazwa'),
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
    final name = ctrl.text.trim();
    if (name.isEmpty) return;

    await context.read<ShoppingListsProvider>().create(name);
  }
}
