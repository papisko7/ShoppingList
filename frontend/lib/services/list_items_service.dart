import 'dart:convert';

import 'package:frontend/core/api/api_client.dart';
import 'package:frontend/models/shopping_list_item.dart';

class ListItemsService {
  final ApiClient api;
  ListItemsService(this.api);

  Future<ShoppingListItem> add({
    required int shoppingListId,
    required String productName,
    String? quantity,
    String? categoryName,
  }) async {
    final res = await api.post(
      '/api/ListItems/add-item',
      body: {
        'shoppingListId': shoppingListId,
        'productName': productName,
        'quantity': quantity ?? '',
        'categoryName': categoryName ?? '',
      },
    );

    if (res.statusCode != 200) {
      throw Exception('add item failed');
    }

    return ShoppingListItem.fromJson(jsonDecode(res.body));
  }

  Future<void> toggle(int id) async {
    final res = await api.patch('/api/ListItems/toggle-item/$id');
    if (res.statusCode != 200) throw Exception('toggle failed');
  }

  Future<void> updateQuantity(int id, String quantity) async {
    final res = await api.put(
      '/api/ListItems/update-item/$id',
      body: {'quantity': quantity},
    );
    if (res.statusCode != 200) throw Exception('update failed');
  }

  Future<void> remove(int id) async {
    final res = await api.delete('/api/ListItems/remove-item/$id');
    if (res.statusCode != 200) throw Exception('remove failed');
  }
}
