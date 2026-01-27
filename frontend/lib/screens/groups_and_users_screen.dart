import 'package:flutter/material.dart';
import 'package:frontend/ui/sidebar/sidebar_layout.dart';
import 'package:frontend/ui/top_app_bar/top_app_bar.dart';
import 'package:provider/provider.dart';
import 'package:frontend/providers/groups_provider.dart';

class GroupsAndUsersScreen extends StatefulWidget {
  const GroupsAndUsersScreen({super.key});

  @override
  State<GroupsAndUsersScreen> createState() => _GroupsAndUsersScreenState();
}

class _GroupsAndUsersScreenState extends State<GroupsAndUsersScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<GroupsProvider>().fetchMyGroups());
  }

  @override
  Widget build(BuildContext context) {
    final groupsProv = context.watch<GroupsProvider>();

    return Scaffold(
      appBar: TopAppBar(
        username: "Jakub Bromber",
        onLogout: () {
          Navigator.pushReplacementNamed(context, '/login');
        },
      ),

      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showCreateGroupDialog(context),
        icon: const Icon(Icons.add),
        label: const Text('Dodaj grupę'),
      ),

      body: SidebarLayout(
        active: "groups",
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: _buildContent(groupsProv),
        ),
      ),
    );
  }

  Widget _buildContent(GroupsProvider groupsProv) {
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
              print('[GROUPS SCREEN] open group id=${g.id}');
            },
          ),
        );
      },
    );
  }

  // =========================
  // CREATE GROUP DIALOG
  // =========================

  Future<void> _showCreateGroupDialog(BuildContext context) async {
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

    if (confirmed != true) return;

    final name = controller.text.trim();
    if (name.isEmpty) return;

    try {
      await context.read<GroupsProvider>().createGroup(name);

      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Grupa utworzona ✅')));
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nie udało się utworzyć grupy ❌')),
      );
    }
  }
}
