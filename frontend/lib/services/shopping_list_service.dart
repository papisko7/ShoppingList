import 'dart:convert';
import 'package:frontend/core/api/api_client.dart';
import 'package:frontend/models/shopping_list.dart';
import 'package:frontend/models/shopping_list_item.dart';

class ShoppingListService {
  final ApiClient api;
  ShoppingListService(this.api);

  // ================= LISTY =================

  Future<List<ShoppingList>> getMyLists() async {
    final res = await api.get('/api/Lists/get-my-lists');
    if (res.statusCode != 200) {
      throw Exception('get-my-lists failed');
    }

    final data = jsonDecode(res.body) as List;
    return data.map((e) => ShoppingList.fromJson(e)).toList();
  }

  Future<ShoppingList> getDetails(int id) async {
    final res = await api.get('/api/Lists/get-list-details/$id');
    if (res.statusCode != 200) {
      throw Exception('get-list-details failed');
    }

    return ShoppingList.fromJson(jsonDecode(res.body));
  }

  Future<ShoppingList> create(String name) async {
    final res = await api.post(
      '/api/Lists/create-list',
      body: {'name': name, 'groupId': null},
    );

    if (res.statusCode != 200) {
      throw Exception('create-list failed');
    }

    return ShoppingList.fromJson(jsonDecode(res.body));
  }

  Future<void> delete(int id) async {
    final res = await api.delete('/api/Lists/delete-list/$id');
    if (res.statusCode != 200) {
      throw Exception('delete-list failed');
    }
  }

  // ================= ITEMY =================

  Future<ShoppingListItem> addItem({
    required int listId,
    required String productName,
    required String quantity,
    String? categoryName,
  }) async {
    final res = await api.post(
      '/api/ListItems/add-item',
      body: {
        'shoppingListId': listId,
        'productName': productName,
        'quantity': quantity,
        'categoryName': categoryName ?? '',
      },
    );

    if (res.statusCode != 200) {
      throw Exception('add-item failed');
    }

    return ShoppingListItem.fromJson(jsonDecode(res.body));
  }

  Future<void> toggleItem(int itemId) async {
    final res = await api.patch('/api/ListItems/toggle-item/$itemId');
    if (res.statusCode != 200) {
      throw Exception('toggle-item failed');
    }
  }

  Future<void> updateItem(int itemId, String quantity) async {
    final res = await api.put(
      '/api/ListItems/update-item/$itemId',
      body: {'quantity': quantity},
    );
    if (res.statusCode != 200) {
      throw Exception('update-item failed');
    }
  }

  Future<void> removeItem(int itemId) async {
    final res = await api.delete('/api/ListItems/remove-item/$itemId');
    if (res.statusCode != 200) {
      throw Exception('remove-item failed');
    }
  }
}
