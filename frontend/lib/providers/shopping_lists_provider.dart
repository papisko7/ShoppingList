import 'package:flutter/material.dart';
import 'package:frontend/models/shopping_list.dart';
import 'package:frontend/services/shopping_list_service.dart';

class ShoppingListsProvider extends ChangeNotifier {
  final ShoppingListService service;
  ShoppingListsProvider({required this.service});

  bool isLoading = false;
  String? error;
  List<ShoppingList> lists = [];

  Future<void> fetch() async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      lists = await service.getMyLists();
    } catch (_) {
      error = 'Nie udało się pobrać list';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> create(String name) async {
    final created = await service.create(name);
    lists = [created, ...lists];
    notifyListeners();
  }

  Future<void> delete(int id) async {
    await service.delete(id);
    lists = lists.where((l) => l.id != id).toList();
    notifyListeners();
  }
}
