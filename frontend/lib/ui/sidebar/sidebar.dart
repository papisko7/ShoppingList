import 'package:flutter/material.dart';
import 'sidebar_item.dart';

class Sidebar extends StatelessWidget {
  final String active;

  const Sidebar({super.key, required this.active});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 260,
      padding: const EdgeInsets.all(16),
      color: Theme.of(context).colorScheme.surfaceVariant,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Menu",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 24),

          SidebarItem(
            title: "Dashboard",
            icon: Icons.dashboard,
            active: active == "dashboard",
            onTap: () {
              Navigator.pushReplacementNamed(context, '/dashboard');
            },
          ),
          const SizedBox(height: 12),

          SidebarItem(
            title: "Moje listy zakupów",
            icon: Icons.list_alt,
            active: active == "lists",
            onTap: () {
              Navigator.pushReplacementNamed(context, '/shopping_lists');
            },
          ),
          const SizedBox(height: 12),

          SidebarItem(
            title: "Grupy i użytkownicy",
            icon: Icons.group,
            active: active == "groups",
            onTap: () {
              Navigator.pushReplacementNamed(context, '/groups_and_users');
            },
          ),
          const SizedBox(height: 12),

          SidebarItem(
            title: "Kategorie i produkty",
            icon: Icons.category,
            active: active == "categories",
            onTap: () {
              Navigator.pushReplacementNamed(
                context,
                '/categories_and_products',
              );
            },
          ),
        ],
      ),
    );
  }
}
