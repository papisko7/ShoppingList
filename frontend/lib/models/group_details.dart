import 'package:frontend/models/shopping_list.dart';

class GroupDetails {
  final int id;
  final String name;
  final String joinCode;
  final List<String> members;
  final List<ShoppingList> lists;

  GroupDetails({
    required this.id,
    required this.name,
    required this.joinCode,
    required this.members,
    required this.lists,
  });

  factory GroupDetails.fromJson(Map<String, dynamic> json) {
    return GroupDetails(
      id: json['id'],
      name: json['name'],
      joinCode: json['joinCode'],
      members: List<String>.from(json['members']),
      lists: (json['lists'] as List)
          .map((e) => ShoppingList.fromJson(e))
          .toList(),
    );
  }
}
