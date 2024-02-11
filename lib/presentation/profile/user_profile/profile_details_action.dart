import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:ipicku_dating_app/data/repositories/user_repositories.dart';
import 'package:ipicku_dating_app/presentation/chatpage/widget/chat_person.dart';
import 'package:ipicku_dating_app/presentation/ui_utils/colors.dart';

class ProfileDetailsAction extends StatelessWidget {
  final String userid, selected;
  const ProfileDetailsAction({
    super.key,
    required this.userid,
    required this.selected,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton.icon(
          onPressed: () async {
             final userData = await UserRepository().getUserMap();
            final users =await
                FirebaseFirestore.instance.collection('users').doc(selected).get();
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) =>
                  ChatPagePerson(currentUser: userData, selectedUser: users.data()),
            ));
          },
          style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.green,
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)))),
          // child: const Text('Cancel', style: TextStyle(color: Colors.black)),
          label: const Text(
            'Message',
            style: TextStyle(
              color: AppTheme.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          icon: const Icon(
            EvaIcons.messageSquare,
            color: AppTheme.black,
          ),
        ),
      ),
    );
  }
}
