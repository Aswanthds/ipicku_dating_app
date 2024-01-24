import 'package:flutter/material.dart';
import 'package:ipicku_dating_app/constants.dart';
import 'package:ipicku_dating_app/data/repositories/user_repositories.dart';
import 'package:ipicku_dating_app/presentation/sign_up/widgets/register_form.dart';

class RegisterScreen extends StatelessWidget {
  final UserRepository userRepository;

  const RegisterScreen({super.key, required this.userRepository});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.kPrimary,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        iconTheme: const IconThemeData(
          color: AppTheme.white,
        ),
      ),
      body: Center(
        child: RegisterForm(userRepository: userRepository),
      ),
    );
  }
}
