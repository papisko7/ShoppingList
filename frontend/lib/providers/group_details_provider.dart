import 'package:flutter/material.dart';
import 'package:frontend/models/group_details.dart';
import 'package:frontend/services/group_details_service.dart';

class GroupDetailsProvider extends ChangeNotifier {
  final GroupDetailsService service;
  final int groupId;

  GroupDetailsProvider({required this.service, required this.groupId});

  GroupDetails? group;
  bool isLoading = false;
  String? error;

  Future<void> fetch() async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      group = await service.getGroupDetails(groupId);
    } catch (_) {
      error = 'Nie udało się pobrać szczegółów grupy';
    }

    isLoading = false;
    notifyListeners();
  }
}
