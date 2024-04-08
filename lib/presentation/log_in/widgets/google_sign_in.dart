// ignore_for_file: use_build_context_synchronously

import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ipicku_dating_app/domain/firebase_data/firebase_data_bloc.dart';
import 'package:ipicku_dating_app/presentation/ui_utils/colors.dart';
import 'package:ipicku_dating_app/data/repositories/user_repositories.dart';
import 'package:ipicku_dating_app/domain/login_bloc/login_bloc.dart';

class GoogleLoginButton extends StatefulWidget {
  final UserRepository userRepository;
  const GoogleLoginButton({super.key, required this.userRepository});

  @override
  State<GoogleLoginButton> createState() => _GoogleLoginButtonState();
}

class _GoogleLoginButtonState extends State<GoogleLoginButton> {
  @override
  Widget build(BuildContext context) {
    int count = 0;
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.redAccent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
      ),
      icon: const Icon(EvaIcons.google, color: AppTheme.white),
      onPressed: () async {
        if (count == 0) {
          BlocProvider.of<LoginBloc>(context).add(GoogleSignUp());
          BlocProvider.of<FirebaseDataBloc>(context)
              .add(const UpdateUserFieldEvent('notifications_picks', true));
          BlocProvider.of<FirebaseDataBloc>(context)
              .add(const UpdateUserFieldEvent('notifications_messages', true));
          BlocProvider.of<FirebaseDataBloc>(context).add(
              const UpdateUserFieldEvent('notifications_recomendations', true));
          setState(() {
            count++;
          });
        }
      },
      label: const Text('Sign in with Google',
          style: TextStyle(color: AppTheme.white)),
    );
  }
}
