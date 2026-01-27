import 'package:flutter/material.dart';
import 'package:frontend/models/product.dart';
import 'package:frontend/services/product_service.dart';

class ProductsProvider extends ChangeNotifier {
  final ProductService service;
  ProductsProvider({required this.service});

  bool isLoading = false;
  String? error;
  List<Product> products = [];

  Future<void> fetch() async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      products = await service.getAll();
    } catch (_) {
      error = 'Nie udało się pobrać produktów';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> create({
    required String productName,
    required int categoryId,
  }) async {
    await service.create(productName: productName, categoryId: categoryId);

    await fetch();
  }

  Future<void> update({
    required int id,
    required String name,
    required int categoryId,
  }) async {
    await service.update(id: id, name: name, categoryId: categoryId);
    products = products.map((p) {
      if (p.id != id) return p;
      return Product(
        id: id,
        name: name,
        categoryId: categoryId,
        categoryName: p.categoryName, // UI może to odświeżyć po fetch
      );
    }).toList();
    notifyListeners();
  }

  Future<void> delete(int id) async {
    await service.delete(id);
    products = products.where((p) => p.id != id).toList();
    notifyListeners();
  }
}
