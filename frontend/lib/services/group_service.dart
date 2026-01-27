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
}
