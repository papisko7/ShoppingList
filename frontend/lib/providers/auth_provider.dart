import 'package:frontend/services/auth_service.dart';
import 'package:flutter/material.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService authService;

  AuthProvider({required this.authService});

  bool _isAuthenticated = false;
  bool _loading = false;

  int? _userId;
  String? _username;

  bool get isAuthenticated => _isAuthenticated;
  bool get loading => _loading;
  int? get userId => _userId;
  String? get username => _username;

  Future<void> init() async {
    print('[AUTH] init');
    _loading = true;
    notifyListeners();

    try {
      await authService.refreshToken();
      _isAuthenticated = true;

      print('[AUTH] Token valid / refreshed');
    } catch (e) {
      print('[AUTH] No valid session');
      _isAuthenticated = false;
    }

    _loading = false;
    notifyListeners();
  }

  Future<void> login(String username, String password) async {
    print('[AUTH] login: $username');

    await authService.login(username, password);

    _isAuthenticated = true;
    _username = username;

    notifyListeners();
  }

  Future<void> register(String username, String password) {
    print('[AUTH] register: $username');

    return authService.register(username, password);
  }

  Future<void> logout() async {
    print('[AUTH] logout');

    await authService.logout();

    _isAuthenticated = false;
    _userId = null;
    _username = null;

    notifyListeners();
  }
}
