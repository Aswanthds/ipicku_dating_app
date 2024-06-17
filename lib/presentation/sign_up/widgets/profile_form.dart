import 'package:flutter/material.dart';
import 'package:ipicku_dating_app/presentation/ui_utils/colors.dart';
import 'package:ipicku_dating_app/domain/profile_bloc/profile_state.dart';

class ProfileSignUpFormField extends StatelessWidget {
  final TextEditingController controller;
  final ProfileState state;
  final IconData? icon;
  final String? Function(String?)? validator;
  final String title;

  const ProfileSignUpFormField({
    super.key,
    required this.controller,
    this.icon,
    required this.state,
    required this.title,
    required this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 10,
      ),
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            gradient: const LinearGradient(colors: [
              AppTheme.pinkAccent,
              AppTheme.red,
            ])),
        child: Container(
          margin: const EdgeInsets.all(2.0),
          padding: const EdgeInsets.all(3.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
          ),
          child: TextFormField(
              controller: controller,
              decoration: InputDecoration(
                hintText: title,
                hintStyle: const TextStyle(color: AppTheme.black),
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
              ),
              style: const TextStyle(
                color: AppTheme.black,
              ),
              autocorrect: false,
              validator: validator),
        ),
      ),
    );
  }
}
