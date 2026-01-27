import 'dart:convert';

import 'package:frontend/core/api/api_client.dart';
import 'package:frontend/models/group.dart';

class GroupService {
  final ApiClient api;

  GroupService(this.api);

  Future<List<Group>> getMyGroups() async {
    print('[GROUP SERVICE] getMyGroups');

    final res = await api.get('/api/Groups/get-my-groups');

    print('[GROUP SERVICE] status: ${res.statusCode}');
    print('[GROUP SERVICE] body: ${res.body}');

    if (res.statusCode != 200) {
      throw Exception('Failed to load groups');
    }

    final List data = jsonDecode(res.body);
    return data.map((group) => Group.fromJson(group)).toList();
  }

  Future<Group> createGroup(String name) async {
    print('[GROUP SERVICE] createGroup name="$name"');

    final res = await api.post(
      '/api/Groups/create-group',
      body: {'name': name},
    );

    print('[GROUP SERVICE] createGroup status: ${res.statusCode}');
    if (res.statusCode != 200 && res.statusCode != 201) {
      print('[GROUP SERVICE] createGroup body: ${res.body}');
      throw Exception('Failed to create group');
    }

    final json = jsonDecode(res.body) as Map<String, dynamic>;
    final created = Group.fromJson(json);

    print('[GROUP SERVICE] created group id=${created.id}');
    return created;
  }
}
