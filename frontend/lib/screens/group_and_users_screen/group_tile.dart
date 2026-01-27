import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:frontend/models/group.dart';
import 'package:frontend/providers/groups_provider.dart';

class GroupTile extends StatelessWidget {
  final Group group;

  const GroupTile({super.key, required this.group});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      child: ListTile(
        title: Text(
          group.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text('Kod: ${group.joinCode} • ${group.memberCount} osób'),
        trailing: PopupMenuButton<String>(
          onSelected: (value) {
            if (value == 'leave') {
              _confirmLeave(context);
            }
          },
          itemBuilder: (_) => const [
            PopupMenuItem(value: 'leave', child: Text('Opuść grupę')),
          ],
        ),
        onTap: () {
          // TODO: GroupDetailsScreen
          print('[GROUP TILE] open group id=${group.id}');
        },
      ),
    );
  }

  Future<void> _confirmLeave(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Opuścić grupę?'),
        content: Text('Czy na pewno chcesz opuścić grupę "${group.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Anuluj'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Opuść'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    try {
      await context.read<GroupsProvider>().leaveGroup(group.id);

      if (!context.mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Opuszczono grupę')));
    } catch (_) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nie udało się opuścić grupy')),
      );
    }
  }
}
