import 'package:flutter/material.dart';

class TopAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String username;
  final VoidCallback onLogout;

  const TopAppBar({super.key, required this.username, required this.onLogout});

  @override
  Widget build(BuildContext context) {
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
