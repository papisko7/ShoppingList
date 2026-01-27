import 'dart:convert';
import 'package:frontend/core/api/api_client.dart';
import 'package:frontend/models/group_details.dart';

class GroupDetailsService {
  final ApiClient api;

  GroupDetailsService({required this.api});

  Future<GroupDetails> getGroupDetails(int groupId) async {
    final res = await api.get('/api/Groups/get-group-details/$groupId');

    if (res.statusCode != 200) {
      throw Exception('Failed to fetch group details');
    }

    return GroupDetails.fromJson(jsonDecode(res.body));
  }
}
