import 'package:flutter/material.dart';
import '../services/mock_auth_service.dart';
import '../ui/auth_button.dart';
import '../ui/auth_text_field.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _username = TextEditingController();
  final _password = TextEditingController();
  final _confirm = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _loading = false;
  String? _error;

  final _auth = MockAuthService();

  Future<void> _handleRegister() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _loading = true;
      _error = null;
    });

    final ok = await _auth.register(
      _username.text.trim(),
      _password.text.trim(),
    );

    setState(() => _loading = false);

    if (!ok) {
      setState(() => _error = "Użytkownik już istnieje");
      return;
    }

    Navigator.pushReplacementNamed(context, "/login");
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
                      "Rejestracja",
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
                        if (!v.contains("@")) return "Niepoprawny username";
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    AuthTextField(
                      controller: _password,
                      label: "Hasło",
                      obscure: true,
                      validator: (v) =>
                          v != null && v.length >= 6 ? null : "Min. 6 znaków",
                    ),
                    const SizedBox(height: 16),

                    AuthTextField(
                      controller: _confirm,
                      label: "Powtórz hasło",
                      obscure: true,
                      validator: (v) =>
                          v == _password.text ? null : "Hasła się różnią",
                    ),
                    const SizedBox(height: 16),

                    if (_error != null)
                      Text(_error!, style: const TextStyle(color: Colors.red)),
                    const SizedBox(height: 16),

                    AuthButton(
                      text: "Zarejestruj",
                      loading: _loading,
                      onPressed: _handleRegister,
                    ),

                    const SizedBox(height: 12),

                    TextButton(
                      onPressed: () =>
                          Navigator.pushReplacementNamed(context, "/login"),
                      child: const Text("Masz konto? Zaloguj się"),
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
