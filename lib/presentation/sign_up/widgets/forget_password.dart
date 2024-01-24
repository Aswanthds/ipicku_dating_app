import 'package:flutter/material.dart';
import 'package:ipicku_dating_app/constants.dart';

class RegisterTitle extends StatelessWidget {
  const RegisterTitle({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Align(
      alignment: Alignment.center,
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: Text(
          "REGISTER",
          style: TextStyle(
            color: AppTheme.white,
            fontWeight: FontWeight.bold,
            fontSize: 28,
          ),
        ),
      ),
    );
  }
}
