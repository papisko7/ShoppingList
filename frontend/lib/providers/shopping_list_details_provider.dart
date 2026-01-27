import 'package:flutter/material.dart';
import 'package:frontend/models/shopping_list.dart';
import 'package:frontend/models/shopping_list_item.dart';
import 'package:frontend/services/shopping_list_service.dart';

class ShoppingListDetailsProvider extends ChangeNotifier {
  final ShoppingListService service;

  ShoppingListDetailsProvider({required this.service});

  ShoppingList? list;
  bool isLoading = false;
  String? error;

  // ================= FETCH =================

  Future<void> fetch(int listId) async {
    isLoading = true;
    notifyListeners();

    try {
      list = await service.getDetails(listId);
    } catch (_) {
      error = 'Nie udało się pobrać listy';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // ================= ADD =================

  Future<void> addItem({
    required int listId,
    required String productName,
    required String quantity,
    String? categoryName,
  }) async {
    final newItem = await service.addItem(
      listId: listId,
      productName: productName,
      quantity: quantity,
      categoryName: categoryName,
    );

    if (list == null) return;

    list = list!.copyWith(items: [...list!.items, newItem]);

    notifyListeners();
  }

  // ================= TOGGLE =================

  Future<void> toggleItem(int itemId) async {
    await service.toggleItem(itemId);
    if (list == null) return;

    list = list!.copyWith(
      items: list!.items.map((item) {
        if (item.id != itemId) return item;

        return ShoppingListItem(
          id: item.id,
          productId: item.productId,
          productName: item.productName,
          categoryName: item.categoryName,
          quantity: item.quantity,
          isBought: !item.isBought,
        );
      }).toList(),
    );

    notifyListeners();
  }

  // ================= REMOVE =================

  Future<void> removeItem(int itemId) async {
    await service.removeItem(itemId);
    if (list == null) return;

    list = list!.copyWith(
      items: list!.items.where((i) => i.id != itemId).toList(),
    );

    notifyListeners();
  }

  // ================= UPDATE QUANTITY =================

  Future<void> updateQuantity(int itemId, String quantity) async {
    await service.updateItem(itemId, quantity);
    if (list == null) return;

    list = list!.copyWith(
      items: list!.items.map((item) {
        if (item.id != itemId) return item;

        return ShoppingListItem(
          id: item.id,
          productId: item.productId,
          productName: item.productName,
          categoryName: item.categoryName,
          quantity: quantity,
          isBought: item.isBought,
        );
      }).toList(),
    );

    notifyListeners();
  }
}
