import 'dart:convert';
import 'package:frontend/core/api/api_client.dart';
import 'package:frontend/models/category.dart';

class CategoryService {
  final ApiClient api;
  CategoryService(this.api);

  Future<List<Category>> getAll() async {
    final res = await api.get('/api/Categories/get-all-categories');
    if (res.statusCode != 200) throw Exception('getAll categories failed');

    final list = jsonDecode(res.body) as List;
    return list.map((e) => Category.fromJson(e)).toList();
  }

  Future<Category> create(String name) async {
    final res = await api.post(
      '/api/Categories/create-category',
      body: {'name': name},
    );
    if (res.statusCode != 200) throw Exception('create category failed');

    return Category.fromJson(jsonDecode(res.body));
  }

  Future<void> update(int id, String name) async {
    final res = await api.put(
      '/api/Categories/update-category/$id',
      body: {'name': name},
    );
    if (res.statusCode != 200) throw Exception('update category failed');
  }

  Future<void> delete(int id) async {
    final res = await api.delete('/api/Categories/delete-category/$id');
    if (res.statusCode != 200) throw Exception('delete category failed');
  }
}
