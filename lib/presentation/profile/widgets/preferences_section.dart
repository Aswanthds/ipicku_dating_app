import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ipicku_dating_app/data/model/user.dart';
import 'package:ipicku_dating_app/data/repositories/user_repositories.dart';
import 'package:ipicku_dating_app/presentation/log_in/forget_password_page.dart';
import 'package:ipicku_dating_app/presentation/profile/widgets/delete_account.dart';
import 'package:ipicku_dating_app/presentation/profile/widgets/profile_details_list.dart';

class PreferencesSection extends StatelessWidget {
  final UserModel? model;
  final UserRepository repo;
  const PreferencesSection({Key? key, required this.model, required this.repo}) : super(key: key);

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
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              " Reset Pasword",
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.start,
              style: TextStyle(
                color: Colors.black,
              ),
            ),
            IconButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const ForgetPasswordPage(),
                ));
              },
              icon: const Icon(
                EvaIcons.arrowIosForward,
              ),
            )
          ],
        ),
        const SizedBox(height: 20),
        ProfileDetailsListTile(
          heading: 'Created on',
          value: DateFormat('dd - MMM - yyyy').format(model!.created!.toDate()),
          isEditable: false,
        ),
        const SizedBox(height: 20),
         DeleteAccountWidget(userRepository: repo),
      ],
    );
  }
}
