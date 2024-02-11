import 'package:flutter/material.dart';
import 'package:ipicku_dating_app/presentation/ui_utils/colors.dart';
import 'package:ipicku_dating_app/data/repositories/user_repositories.dart';
import 'package:ipicku_dating_app/presentation/sign_up/signup.dart';

class CreateAccountButton extends StatelessWidget {
  final UserRepository _userRepository;

  const CreateAccountButton({Key? key, required UserRepository userRepository})
      : _userRepository = userRepository,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "Dont have an account ?",
          style: TextStyle(color: AppTheme.white),
        ),
        TextButton(
          child: const Text(
            'Create an Account',
          ),
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) {
                return RegisterScreen(
                  userRepository: _userRepository,
                );
              }),
            );
          },
        ),
      ],
    );
  }
}
