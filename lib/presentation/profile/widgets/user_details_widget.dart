// ignore_for_file: use_build_context_synchronously

import 'package:ipicku_dating_app/constants.dart';
import 'package:ipicku_dating_app/data/model/user.dart';
import 'package:flutter/material.dart';
import 'package:ipicku_dating_app/presentation/profile/widgets/bio_edit_profile.dart';
import 'package:ipicku_dating_app/presentation/profile/widgets/iterests-data.dart';
import 'package:ipicku_dating_app/presentation/profile/widgets/profile_date.dart';
import 'package:ipicku_dating_app/presentation/profile/widgets/profile_details_list.dart';
import 'package:ipicku_dating_app/presentation/profile/widgets/userphoto_profile_list_widget.dart';

class UserDetailsList extends StatelessWidget {
  final UserModel? user;
  const UserDetailsList({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController emailController = TextEditingController();
    final TextEditingController bioController = TextEditingController();
    final TextEditingController interestController = TextEditingController();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10),
        const Text(
          'User Details',
          style: TextStyle(
            color: AppTheme.black,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        ProfileDetailsListTile(
          heading: 'Name',
          value: '${user?.name}',
          isEditable: true,
          controller: nameController,
          field: 'name',
        ),
        ProfileDetailsListTile(
          heading: 'Email',
          value: '${user?.email}',
          controller: emailController,
          isEditable: false,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Age',
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.start,
              style: TextStyle(
                color: AppTheme.black,
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.only(right: 70.0, top: 8.0, bottom: 8.0),
              child: Text(
                '${user?.age} yrs old',
                textAlign: TextAlign.justify,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppTheme.black,
                ),
              ),
            ),
          ],
        ),
        ProfileDateWidget(user: user),
        BioProfileEditPage(
          value: user?.bio ?? '< Not Set >',
          controller: bioController,
        ),
        InterestDataWidget(user: user, interestController: interestController),
        UserPhotosOwnProfile(user: user),
      ],
    );
  }
}
