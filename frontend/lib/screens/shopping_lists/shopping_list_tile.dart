import 'package:flutter/material.dart';
import 'package:frontend/models/shopping_list.dart';
import 'package:frontend/screens/shopping_list_details/shopping_list_details_screen.dart';
import 'package:provider/provider.dart';
import 'package:frontend/providers/shopping_lists_provider.dart';

class ShoppingListTile extends StatelessWidget {
  final ShoppingList list;
  const ShoppingListTile({super.key, required this.list});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(list.name),
        subtitle: Text('${list.items.length} produktów'),
        trailing: IconButton(
          icon: const Icon(Icons.delete, color: Colors.red),
          onPressed: () =>
              context.read<ShoppingListsProvider>().delete(list.id),
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ShoppingListDetailsScreen(listId: list.id),
            ),
          );
        },
      ),
    );
  }
}
