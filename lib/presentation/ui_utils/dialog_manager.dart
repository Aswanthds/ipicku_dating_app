import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ipicku_dating_app/data/repositories/user_repositories.dart';
import 'package:ipicku_dating_app/domain/auth_bloc/authentication_bloc.dart';
import 'package:ipicku_dating_app/domain/matches_data_bloc/matches_data_bloc.dart';
import 'package:ipicku_dating_app/domain/firebase_data/firebase_data_bloc.dart';
import 'package:ipicku_dating_app/domain/messages/messages_bloc.dart';
import 'package:ipicku_dating_app/presentation/log_in/login.dart';
import 'package:ipicku_dating_app/presentation/ui_utils/colors.dart';

class DialogManager {
  static Future<void> showLogoutDialog(
      BuildContext context, UserRepository repository) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Container(
            height: 300.0,
            width: 300.0,
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  height: 80.0,
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Center(
                    child: Text(
                      'Logout Account',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16.0),
                Text(
                  'Are you sure you want to log out?',
                  style: Theme.of(context).textTheme.displayMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton(
                      child: Text(
                        'Cancel',
                        style: Theme.of(context).textTheme.displaySmall,
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    TextButton.icon(
                      icon: const Icon(
                        EvaIcons.logOut,
                        color: AppTheme.red,
                      ),
                      label: Text(
                        'Logout',
                        style: Theme.of(context).textTheme.displaySmall,
                      ),
                      onPressed: () {
                        BlocProvider.of<AuthenticationBloc>(context)
                            .add(LoggedOut());

                        Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                              builder: (context) =>
                                  SignInPage(userRepository: repository),
                            ),
                            (route) => false);
                      },
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }

  static Future<void> showdeletePickDialog({
    required BuildContext context,
    required Map<String, dynamic> data,
  }) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(5))),
        content: Text(
          "Are you sure you want  unpick ${data['name']}",
          style: Theme.of(context).textTheme.displayMedium,
        ),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                "Cancel",
                style: Theme.of(context).textTheme.bodyLarge,
              )),
          TextButton(
              onPressed: () {
                BlocProvider.of<MatchesDataBloc>(context)
                    .add(RemoveUserFromPick(selectedUserId: data['uid']));
                Navigator.of(context).pop();
              },
              child: Text(
                "Delete",
                style: Theme.of(context).textTheme.bodyLarge,
              ))
        ],
      ),
    );
  }

  static Future<void> showEditDialog(
      {required BuildContext context,
      String? heading,
      String? value,
      required bool isEditable,
      String? field,
      TextEditingController? controller}) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
          title: Text(
            'Edit $heading',
            style: Theme.of(context).textTheme.displayLarge,
          ),
          content: TextFormField(
            controller: controller?..text = value ?? '',
            autocorrect: true,
            maxLines: (field == "bio") ? 5 : 1,
            style: Theme.of(context).textTheme.displaySmall,
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              hintText: "Enter your $heading here",
              hintStyle: Theme.of(context).textTheme.displaySmall,
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                'Cancel',
                style: Theme.of(context).textTheme.displaySmall,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text(
                'Submit',
                style: Theme.of(context).textTheme.displaySmall,
              ),
              onPressed: () {
                BlocProvider.of<FirebaseDataBloc>(context).add(
                  UpdateUserFieldEvent(
                    field ?? '',
                    controller?.text.trim(),
                  ),
                );
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  static Future<void> showDeleteAccountDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Container(
            height: 300.0,
            width: 300.0,
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  height: 80.0,
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Center(
                    child: Text(
                      'Delete Account',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16.0),
                Text(
                  'Are you sure you want to delete your account?',
                  style: Theme.of(context).textTheme.displayMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      style: ElevatedButton.styleFrom(
                          shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)))),
                      child: const Text('Cancel',
                          style: TextStyle(color: Colors.black)),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        BlocProvider.of<AuthenticationBloc>(context)
                            .add(DeleteAccount());
                        Navigator.of(context).pop();
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)))),
                      child: const Text('Delete',
                          style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  static void showChatOptionsPopup(
      BuildContext context, Map<String, dynamic> data) {
    
    showMenu(
      context: context,
      position: const RelativeRect.fromLTRB(100, 120, 0, 10),
      items: [
        PopupMenuItem(
          child: ListTile(
            title: const Text('Delete Chat'),
            onTap: () {
              BlocProvider.of<MessagesBloc>(context)
                  .add(DeleteUserChat(recieverId: data['uid']));
              Navigator.pop(context); // Close the popup
              // Implement your delete chat logic here
            },
          ),
        ),
        PopupMenuItem(
          child: ListTile(
            title: const Text('Block Chat'),
            onTap: () {
              Navigator.pop(context); // Close the popup
              // Implement your block chat logic here
            },
          ),
        ),
        PopupMenuItem(
          child: ListTile(
            title: const Text('Mute Chat'),
            onTap: () {
              Navigator.pop(context); // Close the popup
              // Implement your mute chat logic here
            },
          ),
        ),
      ],
    );
  }
}
