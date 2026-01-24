import 'package:flutter/material.dart';
import 'package:frontend/services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService authService;

  bool _isAuthenticated = false;
  bool get isAuthenticated => _isAuthenticated;

  AuthProvider({required this.authService});

  Future<void> login(String email, String password) async {
    await authService.login(email, password);
    _isAuthenticated = true;
    notifyListeners();
  }

  Future<void> register(String email, String password) async {
    await authService.register(email, password);
  }

  Future<void> logout() async {
    await authService.logout();
    _isAuthenticated = false;
    notifyListeners();
  }
}
