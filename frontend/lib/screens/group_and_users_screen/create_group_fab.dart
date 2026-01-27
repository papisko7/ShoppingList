import 'package:flutter/material.dart';
import 'package:frontend/providers/groups_provider.dart';
import 'package:provider/provider.dart';
import 'create_group_dialog.dart';

class CreateGroupFab extends StatelessWidget {
  const CreateGroupFab({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      icon: const Icon(Icons.add),
      label: const Text('Dodaj grupę'),
      onPressed: () async {
        final groupName = await showCreateGroupDialog(context);
        if (groupName == null) return;

        try {
          await context.read<GroupsProvider>().createGroup(groupName);

          if (!context.mounted) return;
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('Grupa utworzona ✅')));
        } catch (_) {
          if (!context.mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Nie udało się utworzyć grupy ❌')),
          );
        }
      },
    );
  }
}
