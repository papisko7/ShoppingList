import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:frontend/providers/group_details_provider.dart';

class GroupDetailsDialog extends StatelessWidget {
  const GroupDetailsDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final prov = context.watch<GroupDetailsProvider>();

    return Dialog(
      insetPadding: const EdgeInsets.all(32),
      child: SizedBox(
        width: 700,
        height: 600,
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: _buildContent(prov),
        ),
      ),
    );
  }

  Widget _buildContent(GroupDetailsProvider prov) {
    if (prov.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (prov.error != null) {
      return Center(child: Text(prov.error!));
    }

    final g = prov.group!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          g.name,
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text('Kod dołączenia: ${g.joinCode}'),
        const Divider(height: 32),

        const Text('Członkowie', style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: g.members.map((m) => Chip(label: Text(m))).toList(),
        ),

        const Divider(height: 32),

        const Text(
          'Listy zakupowe',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),

        Expanded(
          child: ListView.builder(
            itemCount: g.lists.length,
            itemBuilder: (_, i) {
              final list = g.lists[i];
              return ListTile(
                title: Text(list.name),
                subtitle: Text('Elementów: ${list.items.length}'),
              );
            },
          ),
        ),
      ],
    );
  }
}
