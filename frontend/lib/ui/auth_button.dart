import 'package:flutter/material.dart';

class AuthButton extends StatelessWidget {
  final String text;
  final bool loading;
  final VoidCallback onPressed;

  const AuthButton({
    super.key,
    required this.text,
    required this.loading,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: loading ? null : onPressed,
        child: loading
            ? const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : Text(text),
      ),
    );
  }
}
