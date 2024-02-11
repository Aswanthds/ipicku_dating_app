import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:ipicku_dating_app/presentation/ui_utils/colors.dart';
import 'package:ipicku_dating_app/data/repositories/user_repositories.dart';
import 'package:ipicku_dating_app/domain/login_bloc/login_bloc.dart';

import 'package:ipicku_dating_app/presentation/log_in/widgets/formwidget.dart';

class SignInPage extends StatelessWidget {
  final UserRepository userRepository;
  const SignInPage({super.key, required this.userRepository});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppTheme.kPrimary,
      body: Center(
        child: BlocProvider(
          create: (context) => LoginBloc(userRepository: userRepository),
          child: LoginForm(userRepository: userRepository),
        ),
      ),
    );
  }
}
