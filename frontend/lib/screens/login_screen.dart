import 'package:flutter/material.dart';
import '../services/mock_auth_service.dart';
import '../ui/auth_button.dart';
import '../ui/auth_text_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _username = TextEditingController();
  final _password = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _loading = false;
  String? _error;

  final _auth = MockAuthService();

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _loading = true;
      _error = null;
    });

    final ok = await _auth.login(_username.text.trim(), _password.text.trim());

    setState(() => _loading = false);

    if (!ok) {
      setState(() => _error = "Niepoprawne dane logowania");
      return;
    }

    Navigator.pushReplacementNamed(context, "/dashboard");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Card(
            elevation: 3,
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      "Logowanie",
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 24),

                    AuthTextField(
                      controller: _username,
                      label: "Username",
                      validator: (v) {
                        if (v == null || v.isEmpty) return "Podaj username";
                        return null;
                      },
                    ),

                    const SizedBox(height: 16),

                    AuthTextField(
                      controller: _password,
                      label: "Hasło",
                      obscure: true,
                      validator: (v) =>
                          v == null || v.isEmpty ? "Podaj hasło" : null,
                    ),

                    const SizedBox(height: 16),

                    if (_error != null)
                      Text(_error!, style: const TextStyle(color: Colors.red)),
                    const SizedBox(height: 16),

                    AuthButton(
                      text: "Zaloguj",
                      loading: _loading,
                      onPressed: _handleLogin,
                    ),

                    const SizedBox(height: 12),

                    TextButton(
                      onPressed: () =>
                          Navigator.pushReplacementNamed(context, "/register"),
                      child: const Text("Nie masz konta? Zarejestruj się"),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
