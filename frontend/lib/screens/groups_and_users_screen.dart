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

    if (groupsProv.isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (groupsProv.error != null) {
      return Scaffold(body: Center(child: Text(groupsProv.error!)));
    }

    return Scaffold(
      appBar: TopAppBar(
        username: "Jakub Bromber",
        onLogout: () {
          Navigator.pushReplacementNamed(context, '/login');
        },
      ),
      body: SidebarLayout(
        active: "groups", // 👈 ważne (dopasuj do sidebaru)
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: ListView.builder(
            itemCount: groupsProv.groups.length,
            itemBuilder: (context, i) {
              final g = groupsProv.groups[i];
              return Card(
                child: ListTile(
                  title: Text(g.name),
                  subtitle: Text('Kod: ${g.joinCode} • ${g.memberCount} osób'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    // TODO: przejście do GroupDetails
                  },
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
