class Group {
  final int id;
  final String name;
  final String joinCode;
  final int memberCount;
  final DateTime createdAt;

  Group({
    required this.id,
    required this.name,
    required this.joinCode,
    required this.memberCount,
    required this.createdAt,
  });

  factory Group.fromJson(Map<String, dynamic> json) {
    return Group(
      id: json['id'],
      name: json['name'],
      joinCode: json['joinCode'],
      memberCount: json['memberCount'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}
