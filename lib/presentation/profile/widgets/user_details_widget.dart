import 'package:flutter/material.dart';
import 'package:ipicku_dating_app/presentation/profile/widgets/profile_details_list.dart';

class UserDetailsList extends StatelessWidget {
  const UserDetailsList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10),
        const Text(
          'User Details',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        ProfileDetailsListTile(
          context :context,
          heading: 'Name',
          value: 'Aswanth DS',
          isEditable: true,
        ),
        ProfileDetailsListTile(
         context: context,
          heading: 'Email',
          value: 'aswanthds2005@gmail.com',
          isEditable: true,
        ),
        ProfileDetailsListTile(
          context: context,
          heading: 'Age',
          value: '18',
          isEditable: true,
        ),
        ProfileDetailsListTile(
         context: context,
          heading: 'Date of Birth',
          value: 'June 18,2005',
          isEditable: true,
        ),
        ProfileDetailsListTile(
          context: context,
          heading: 'Region',
          value: 'Kerala',
          isEditable: true,
        ),
        ProfileDetailsListTile(
         context: context,
          heading: 'Bio',
          value: 'Looking for a partner ',
          isEditable: true,
        ),
        // ProfileDetailsListTile(
        //  context: context,
        //   heading: 'Interests',
        //   value: 'Aswanth DS',
        //   isEditable: true,
        // ),
      ],
    );
  }
}
