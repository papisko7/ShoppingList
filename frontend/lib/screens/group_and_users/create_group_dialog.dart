import 'package:flutter/material.dart';

Future<String?> showCreateGroupDialog(BuildContext context) async {
  final controller = TextEditingController();

  final confirmed = await showDialog<bool>(
    context: context,
    builder: (_) => AlertDialog(
      title: const Text('Nowa grupa'),
      content: TextField(
        controller: controller,
        autofocus: true,
        decoration: const InputDecoration(
          labelText: 'Nazwa grupy',
          hintText: 'np. Dom, Studia, Praca',
        ),
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

  if (confirmed != true) return null;

  final name = controller.text.trim();
  if (name.isEmpty) return null;

  return name;
}
