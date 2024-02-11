import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ipicku_dating_app/presentation/ui_utils/colors.dart';
import 'package:ipicku_dating_app/data/repositories/user_repositories.dart';
import 'package:ipicku_dating_app/domain/auth_bloc/authentication_bloc.dart';
import 'package:ipicku_dating_app/presentation/log_in/login.dart';
import 'package:ipicku_dating_app/presentation/ui_utils/constants.dart';
import 'package:ipicku_dating_app/presentation/ui_utils/dialog_manager.dart';

class DeleteAccountWidget extends StatelessWidget {
  final UserRepository userRepository;
  const DeleteAccountWidget({
    super.key,
    required this.userRepository,
  });

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthenticationBloc, AuthenticationState>(
      listener: (context, state) {
        if (state is AccountDeletingState) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBarManager.deleteLoadingSnackbar);
        }
        if (state is AccountDeletingFailed) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBarManager.deletefailedSnackbar);
        }
        if (state is AccountDeletedState) {
          BlocProvider.of<AuthenticationBloc>(context).add(LoggedOut());
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (context) =>
                    SignInPage(userRepository: userRepository),
              ),
              (route) => false);
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBarManager.deleteDoneSnackbar);
        }
      },
      child: BlocBuilder<AuthenticationBloc, AuthenticationState>(
        builder: (context, state) {
          return SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                  side: const BorderSide(
                color: AppTheme.kPrimary,
                style: BorderStyle.solid,
                width: 1.5,
              )),
              onPressed: () => DialogManager.showDeleteAccountDialog(context),
              icon: const Icon(
                EvaIcons.trash2,
                color: AppTheme.kPrimary,
              ),
              label: const Text(
                "Delete Account",
                style: TextStyle(
                  color: AppTheme.kPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
