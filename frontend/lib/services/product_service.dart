import 'dart:convert';
import 'package:frontend/core/api/api_client.dart';
import 'package:frontend/models/product.dart';

class ProductService {
  final ApiClient api;
  ProductService(this.api);

  Future<List<Product>> getAll() async {
    final res = await api.get('/api/Products/get-all-products');
    if (res.statusCode != 200) throw Exception('getAll products failed');

    final list = jsonDecode(res.body) as List;
    return list.map((e) => Product.fromJson(e)).toList();
  }

  Future<Product> create({
    required String productName,
    required int categoryId,
    String? categoryName, // backend i tak zwraca categoryName w odpowiedzi
    int?
    shoppingListId, // jeśli backend tego wymaga dla add-to-list, tu nie używamy
    String? quantity,
  }) async {
    final res = await api.post(
      '/api/Products/create-product',
      body: {
        'productName':
            productName, // UWAGA: u Ciebie DTO ma productName (z obrazka)
        'categoryName': categoryName ?? '',
        'categoryId': categoryId,
        // 'shoppingListId': shoppingListId, // jeśli endpoint wymaga – dopisz
        // 'quantity': quantity,
      },
    );

    if (res.statusCode != 200) throw Exception('create product failed');
    return Product.fromJson(jsonDecode(res.body));
  }

  Future<void> update({
    required int id,
    required String name,
    required int categoryId,
  }) async {
    final res = await api.put(
      '/api/Products/update-product/$id',
      body: {'name': name, 'categoryId': categoryId},
    );
    if (res.statusCode != 200) throw Exception('update product failed');
  }

  Future<void> delete(int id) async {
    final res = await api.delete('/api/Products/delete-product/$id');
    if (res.statusCode != 200) throw Exception('delete product failed');
  }
}
