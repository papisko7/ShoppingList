import 'package:flutter/material.dart';
import 'package:frontend/providers/shopping_list_details_provider.dart';
import 'package:frontend/screens/shopping_list_details/add_list_item_fab.dart';
import 'package:frontend/screens/shopping_lists/shopping_list_item_tile.dart';
import 'package:provider/provider.dart';

class ShoppingListDetailsScreen extends StatefulWidget {
  final int listId;
  const ShoppingListDetailsScreen({super.key, required this.listId});

  @override
  State<ShoppingListDetailsScreen> createState() =>
      _ShoppingListDetailsScreenState();
}

class _ShoppingListDetailsScreenState extends State<ShoppingListDetailsScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<ShoppingListDetailsProvider>().fetch(widget.listId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final prov = context.watch<ShoppingListDetailsProvider>();

    return Scaffold(
      appBar: AppBar(title: Text(prov.list?.name ?? 'Lista')),
      floatingActionButton: AddListItemFab(listId: widget.listId),
      body: _buildBody(prov),
    );
  }

  Widget _buildBody(ShoppingListDetailsProvider prov) {
    if (prov.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (prov.error != null) {
      return Center(child: Text(prov.error!));
    }

    final items = prov.list!.items;

    if (items.isEmpty) {
      return const Center(child: Text('Brak produktów'));
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: items.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (_, i) => ShoppingListItemTile(
        item: items[i],
        onToggle: () {
          context.read<ShoppingListDetailsProvider>().toggleItem(items[i].id);
        },
        onDelete: () {
          context.read<ShoppingListDetailsProvider>().removeItem(items[i].id);
        },
      ),
    );
  }
}
