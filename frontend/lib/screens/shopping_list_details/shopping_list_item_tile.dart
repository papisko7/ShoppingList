import 'package:flutter/material.dart';
import 'package:frontend/models/shopping_list_item.dart';
import 'package:frontend/providers/shopping_list_details_provider.dart';
import 'package:provider/provider.dart';

class ShoppingListItemTile extends StatelessWidget {
  final ShoppingListItem item;
  const ShoppingListItemTile({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Checkbox(
          value: item.isBought,
          onChanged: (_) {
            context.read<ShoppingListDetailsProvider>().toggleItem(item.id);
          },
        ),
        title: Text(
          item.productName,
          style: TextStyle(
            decoration: item.isBought ? TextDecoration.lineThrough : null,
          ),
        ),
        subtitle: Text('${item.quantity} • ${item.categoryName ?? ''}'),
        trailing: IconButton(
          icon: const Icon(Icons.delete),
          onPressed: () {
            context.read<ShoppingListDetailsProvider>().removeItem(item.id);
          },
        ),
      ),
    );
  }
}
