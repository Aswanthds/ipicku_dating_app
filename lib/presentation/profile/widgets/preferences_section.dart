import 'package:flutter/material.dart';
import 'package:ipicku_dating_app/presentation/profile/widgets/delete_account.dart';
import 'package:ipicku_dating_app/presentation/profile/widgets/profile_details_list.dart';

class PreferencesSection extends StatelessWidget {
  const PreferencesSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        const Text(
          'Security Details',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        const SizedBox(height: 10),
        ProfileDetailsListTile(
          context: context,
          heading: 'Password',
          value: 'Reset your Password',
          isEditable: false,
        ),
        const SizedBox(height: 20),
        ProfileDetailsListTile(
          context: context,
          heading: 'Created on',
          value: 'January 14,2024',
          isEditable: false,
        ),
        const SizedBox(height: 20),
        const DeleteAccountWidget(),
      ],
    );
  }
}
