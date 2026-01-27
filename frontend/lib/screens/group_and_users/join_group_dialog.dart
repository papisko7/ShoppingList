import 'package:flutter/material.dart';

Future<String?> showJoinGroupDialog(BuildContext context) async {
  final controller = TextEditingController();

  final confirmed = await showDialog<bool>(
    context: context,
    builder: (_) => AlertDialog(
      title: const Text('Dołącz do grupy'),
      content: TextField(
        controller: controller,
        autofocus: true,
        decoration: const InputDecoration(
          labelText: 'Kod grupy',
          hintText: 'np. A1B2C',
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: const Text('Anuluj'),
        ),
        ElevatedButton(
          onPressed: () => Navigator.pop(context, true),
          child: const Text('Dołącz'),
        ),
      ],
    ),
  );

  if (confirmed != true) return null;

  final code = controller.text.trim();
  if (code.length < 5) return null;

  return code;
}
