import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
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
    return IconButton.filled(
      onPressed: () async {
        // final userData = await UserRepository().getUserMapAlongwithBloc(selected);
        // final users = await FirebaseFirestore.instance
        //     .collection('users')
        //     .doc(selected)
        //     .get();
        // Navigator.of(context).push(MaterialPageRoute(
        //   builder: (context) => ChatPagePerson(
        //       currentUser: userData, selectedUser: users.data()),
        // ));
      },
      style: IconButton.styleFrom(
        backgroundColor: AppTheme.green,
        
      ),
      // child: const Text('Cancel', style: TextStyle(color: Colors.black)),
    
      icon: const Icon(
        EvaIcons.messageSquare,
        color: AppTheme.black,
         size: 45,
      ),
    );
  }
}
