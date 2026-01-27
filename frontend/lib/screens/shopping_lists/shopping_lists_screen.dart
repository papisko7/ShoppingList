import 'package:flutter/material.dart';
import 'package:frontend/screens/shopping_lists/create_list_fab.dart';
import 'package:frontend/screens/shopping_lists/shopping_list_tile.dart';
import 'package:frontend/ui/sidebar/sidebar_layout.dart';
import 'package:frontend/ui/top_app_bar/top_app_bar.dart';
import 'package:provider/provider.dart';
import 'package:frontend/providers/shopping_lists_provider.dart';

class ShoppingListsScreen extends StatefulWidget {
  const ShoppingListsScreen({super.key});

  @override
  State<ShoppingListsScreen> createState() => _ShoppingListsScreenState();
}

class _ShoppingListsScreenState extends State<ShoppingListsScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<ShoppingListsProvider>().fetch();
    });
  }

  @override
  Widget build(BuildContext context) {
    final prov = context.watch<ShoppingListsProvider>();

    return Scaffold(
      appBar: TopAppBar(
        onLogout: () => Navigator.pushReplacementNamed(context, '/login'),
      ),
      floatingActionButton: const CreateListFab(),
      body: SidebarLayout(
        active: 'lists',
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: _buildBody(prov),
        ),
      ),
    );
  }

  Widget _buildBody(ShoppingListsProvider prov) {
    if (prov.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (prov.error != null) {
      return Center(child: Text(prov.error!));
    }

    if (prov.lists.isEmpty) {
      return const Center(child: Text('Brak list zakupów'));
    }

    return ListView.separated(
      itemCount: prov.lists.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (_, i) => ShoppingListTile(list: prov.lists[i]),
    );
  }
}
