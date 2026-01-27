import 'package:frontend/models/shopping_list_item.dart';

class ShoppingList {
  final int id;
  final String name;
  final DateTime createdAt;
  final List<ShoppingListItem> items;

  ShoppingList({
    required this.id,
    required this.name,
    required this.createdAt,
    required this.items,
  });

  ShoppingList copyWith({List<ShoppingListItem>? items}) {
    return ShoppingList(
      id: id,
      name: name,
      createdAt: createdAt,
      items: items ?? this.items,
    );
  }

  factory ShoppingList.fromJson(Map<String, dynamic> json) {
    return ShoppingList(
      id: json['id'],
      name: json['name'],
      createdAt: DateTime.parse(json['createdAt']),
      items: json['items'] != null
          ? (json['items'] as List)
                .map((e) => ShoppingListItem.fromJson(e))
                .toList()
          : [],
    );
  }
}
