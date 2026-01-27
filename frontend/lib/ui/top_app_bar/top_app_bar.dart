import 'package:flutter/material.dart';
import 'package:frontend/providers/auth_provider.dart';
import 'package:provider/provider.dart';

class TopAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback onLogout;

  const TopAppBar({super.key, required this.onLogout});

  @override
  Widget build(BuildContext context) {
    final username = context.watch<AuthProvider>().username ?? 'Użytkownik';
    return AppBar(
      backgroundColor: Colors.green,
      actions: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Center(
            child: Text(username, style: const TextStyle(fontSize: 16)),
          ),
        ),
        IconButton(
          onPressed: onLogout,
          icon: const Icon(Icons.logout),
          tooltip: "Wyloguj",
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
