import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:ipicku_dating_app/constants.dart';

class DeleteAccountWidget extends StatelessWidget {
  const DeleteAccountWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        style: OutlinedButton.styleFrom(
            side: const BorderSide(
          color: kPrimary,
          style: BorderStyle.solid,
          width: 1.5,
        )),
        onPressed: () {},
        icon: const Icon(
          EvaIcons.trash2,
          color: kPrimary,
        ),
        label: const Text(
          "Delete Account",
          style: TextStyle(
            color: kPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
