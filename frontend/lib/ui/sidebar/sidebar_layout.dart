import 'package:flutter/material.dart';
import 'sidebar.dart';

class SidebarLayout extends StatelessWidget {
  final String active;
  final Widget child;

  const SidebarLayout({super.key, required this.active, required this.child});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Sidebar po lewej
        SafeArea(child: Sidebar(active: active)),

        // Główna zawartość
        Expanded(child: SafeArea(child: child)),
      ],
    );
  }
}
