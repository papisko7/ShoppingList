class MockAuthService {
  final Map<String, String> _users = {'test@example.com': 'password123'};

  Future<bool> login(String email, String password) async {
    await Future.delayed(const Duration(seconds: 1)); // Simulate network delay
    return _users[email] == password;
  }

  Future<bool> register(String email, String password) async {
    await Future.delayed(const Duration(milliseconds: 500));
    if (_users.containsKey(email)) return false;

    _users[email] = password;
    return true;
  }
}
