import 'package:flutter/material.dart';
import 'package:ipicku_dating_app/presentation/ui_utils/colors.dart';

class RegisterButton extends StatelessWidget {
  final VoidCallback? _onPressed;

  const RegisterButton({Key? key, VoidCallback? onPressed})
      : _onPressed = onPressed,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppTheme.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
      ),
      onPressed: _onPressed,
      child: const Text(
        'Continue',
        style: TextStyle(
          color: AppTheme.black,
        ),
      ),
    );
  }
}
