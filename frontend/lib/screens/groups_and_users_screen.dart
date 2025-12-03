import 'package:flutter/material.dart';
import 'package:frontend/ui/sidebar/sidebar_layout.dart';

class GroupsAndUsersScreen extends StatelessWidget {
  const GroupsAndUsersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Groups and Users"),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/login');
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: SidebarLayout(
        active: "groups",
        child: SingleChildScrollView(
          // ← dodane
          padding: const EdgeInsets.all(32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                "Witaj 👋",
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 24),
              Text("Zawartość grup i użytkowników..."),
            ],
          ),
        ),
      ),
    );
  }
}
