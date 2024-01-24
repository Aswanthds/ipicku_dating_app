// ignore_for_file: use_build_context_synchronously

import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ipicku_dating_app/constants.dart';
import 'package:ipicku_dating_app/data/repositories/user_repositories.dart';
import 'package:ipicku_dating_app/domain/login_bloc/login_bloc.dart';

class GoogleLoginButton extends StatelessWidget {
  final UserRepository userRepository;
  const GoogleLoginButton({super.key, required this.userRepository});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.redAccent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
      ),
      icon: const Icon(EvaIcons.google, color: AppTheme.white),
      onPressed: () async {
        BlocProvider.of<LoginBloc>(context).add(GoogleSignUp());
      },
      label: const Text('Sign in with Google',
          style: TextStyle(color: AppTheme.white)),
    );
  }
}
