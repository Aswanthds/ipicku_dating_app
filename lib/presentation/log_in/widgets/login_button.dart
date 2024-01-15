import 'package:flutter/material.dart';

class LoginButton extends StatelessWidget {
  final VoidCallback? _onPressed;

  const LoginButton({Key? key, required VoidCallback? onPressed})
      : _onPressed = onPressed,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
      ),
      onPressed: _onPressed,
      child: const Text('Login'),
    );
  }
}
