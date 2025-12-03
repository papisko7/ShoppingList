class MockAuthService {
  final Map<String, String> _users = {'test@example.com': 'password123'};

  Future<bool> login(String username, String password) async {
    await Future.delayed(const Duration(seconds: 1)); // Simulate network delay
    return _users[username] == password;
  }

  Future<bool> register(String username, String password) async {
    await Future.delayed(const Duration(milliseconds: 500));
    if (_users.containsKey(username)) return false;

    _users[username] = password;
    return true;
  }
}
