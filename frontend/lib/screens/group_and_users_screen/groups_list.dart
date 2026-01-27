import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:frontend/providers/groups_provider.dart';

class GroupsList extends StatelessWidget {
  const GroupsList({super.key});

  @override
  Widget build(BuildContext context) {
    final groupsProv = context.watch<GroupsProvider>();

    if (groupsProv.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (groupsProv.error != null) {
      return Center(
        child: Text(
          groupsProv.error!,
          style: const TextStyle(color: Colors.red),
        ),
      );
    }

    if (groupsProv.groups.isEmpty) {
      return const Center(
        child: Text(
          'Nie należysz jeszcze do żadnej grupy',
          style: TextStyle(fontSize: 16),
        ),
      );
    }

    return ListView.separated(
      itemCount: groupsProv.groups.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, i) {
        final g = groupsProv.groups[i];

        return Card(
          elevation: 1,
          child: ListTile(
            title: Text(
              g.name,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text('Kod: ${g.joinCode} • ${g.memberCount} osób'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              // TODO: GroupDetailsScreen
              print('[GROUPS LIST] open group id=${g.id}');
            },
          ),
        );
      },
    );
  }
}
