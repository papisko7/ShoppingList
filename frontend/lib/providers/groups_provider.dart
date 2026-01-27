import 'package:flutter/material.dart';
import 'package:frontend/models/group.dart';
import 'package:frontend/services/group_service.dart';

class GroupsProvider extends ChangeNotifier {
  final GroupService service;

  GroupsProvider({required this.service});

  List<Group> _groups = [];
  bool _loading = false;
  String? _error;

  List<Group> get groups => _groups;
  bool get isLoading => _loading;
  String? get error => _error;

  Future<void> fetchMyGroups() async {
    print('[GROUPS PROVIDER] fetchMyGroups');

    _loading = true;
    _error = null;
    notifyListeners();

    try {
      _groups = await service.getMyGroups();
      print('[GROUPS PROVIDER] loaded ${_groups.length} groups');
    } catch (e) {
      print('[GROUPS PROVIDER] error: $e');
      _error = 'Nie udało się pobrać grup';
    }

    _loading = false;
    notifyListeners();
  }

  void clear() {
    _groups = [];
    _error = null;
    notifyListeners();
  }
}
