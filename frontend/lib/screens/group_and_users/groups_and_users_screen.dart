import 'package:flutter/material.dart';
import 'package:frontend/screens/group_and_users/create_group_fab.dart';
import 'package:frontend/screens/group_and_users/groups_list.dart';
import 'package:frontend/screens/group_and_users/join_group_fab.dart';
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
    return Scaffold(
      appBar: TopAppBar(
        onLogout: () {
          Navigator.pushReplacementNamed(context, '/login');
        },
      ),

      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: const [
          JoinGroupFab(),
          SizedBox(height: 12),
          CreateGroupFab(),
        ],
      ),

      body: SidebarLayout(
        active: "groups",
        child: const Padding(padding: EdgeInsets.all(32), child: GroupsList()),
      ),
    );
  }
}
