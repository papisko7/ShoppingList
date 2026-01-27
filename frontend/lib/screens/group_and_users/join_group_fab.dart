import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:frontend/providers/groups_provider.dart';
import 'join_group_dialog.dart';

class JoinGroupFab extends StatelessWidget {
  const JoinGroupFab({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      heroTag: 'join-group',
      icon: const Icon(Icons.group_add),
      label: const Text('Dołącz do grupy'),
      onPressed: () async {
        final joinCode = await showJoinGroupDialog(context);
        if (joinCode == null) return;

        try {
          await context.read<GroupsProvider>().joinGroup(joinCode);

          if (!context.mounted) return;
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('Dołączono do grupy ✅')));
        } catch (_) {
          if (!context.mounted) return;
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('Nieprawidłowy kod ❌')));
        }
      },
    );
  }
}
