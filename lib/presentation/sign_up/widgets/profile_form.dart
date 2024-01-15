import 'package:flutter/material.dart';
import 'package:ipicku_dating_app/domain/profile_bloc/profile_state.dart';

class ProfileSignUpFormField extends StatelessWidget {
  final TextEditingController controller;
  final ProfileState state;
  final IconData? icon;

  const ProfileSignUpFormField({
    super.key,
    required this.controller,
    this.icon,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 10,
      ),
      child: TextFormField(
        controller: controller,

        decoration: const InputDecoration(
          labelText: "Name",
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(15),
            ),
            borderSide: BorderSide(
              color: Colors.white,
              style: BorderStyle.solid,
            ),
          ),
          labelStyle: TextStyle(color: Colors.white),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(15),
            ),
            borderSide: BorderSide(
              color: Colors.grey,
              style: BorderStyle.solid,
            ),
          ),
        ),
        //autovalidate: true,
        style: const TextStyle(
          color: Colors.white,
        ),
        autocorrect: false,
        validator: (value) {
          value!.isEmpty ? "Enter your name" : null;
          return null;
        },
      ),
    );
  }
}
