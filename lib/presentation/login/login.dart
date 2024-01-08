import 'package:flutter/material.dart';

import 'package:ipicku_dating_app/constants.dart';
import 'package:ipicku_dating_app/data/repositories/user_repositories.dart';

import 'package:ipicku_dating_app/presentation/login/widgets/formwidget.dart';

class SignInPage extends StatelessWidget {
  final UserRepository userRepository;
  const SignInPage({super.key, required this.userRepository});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: kPrimary,
      body: Center(
        child: LoginForm(userRepository: userRepository ),
      ),
    );
  }
}
