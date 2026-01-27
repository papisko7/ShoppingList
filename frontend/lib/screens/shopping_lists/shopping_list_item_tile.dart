import 'package:flutter/material.dart';
import 'package:frontend/models/shopping_list_item.dart';

class ShoppingListItemTile extends StatelessWidget {
  final ShoppingListItem item;
  final VoidCallback onToggle;
  final VoidCallback onDelete;

  const ShoppingListItemTile({
    super.key,
    required this.item,
    required this.onToggle,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      value: item.isBought,
      onChanged: (_) => onToggle(),
      title: Text(
        item.productName,
        style: TextStyle(
          decoration: item.isBought
              ? TextDecoration.lineThrough
              : TextDecoration.none,
        ),
      ),
      subtitle: Text('${item.categoryName} • ${item.quantity}'),
      secondary: IconButton(
        icon: const Icon(Icons.delete),
        onPressed: onDelete,
      ),
    );
  }
}
