import 'package:flutter/material.dart';
import 'package:frontend/models/category.dart';
import 'package:frontend/services/category_service.dart';

class CategoriesProvider extends ChangeNotifier {
  final CategoryService service;
  CategoriesProvider({required this.service});

  bool isLoading = false;
  String? error;
  List<Category> categories = [];

  Future<void> fetch() async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      categories = await service.getAll();
    } catch (_) {
      error = 'Nie udało się pobrać kategorii';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> create(String name) async {
    final created = await service.create(name);
    categories = [created, ...categories];
    notifyListeners();
  }

  Future<void> update(int id, String name) async {
    await service.update(id, name);
    categories = categories
        .map((c) => c.id == id ? Category(id: id, name: name) : c)
        .toList();
    notifyListeners();
  }

  Future<void> delete(int id) async {
    await service.delete(id);
    categories = categories.where((c) => c.id != id).toList();
    notifyListeners();
  }
}
