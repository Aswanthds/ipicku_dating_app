import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:ipicku_dating_app/data/repositories/messaging_repository.dart';
import 'package:ipicku_dating_app/presentation/ui_utils/colors.dart';
import 'package:ipicku_dating_app/presentation/ui_utils/dialog_manager.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:ipicku_dating_app/data/repositories/user_repositories.dart';
import 'package:ipicku_dating_app/presentation/chatpage/widget/chat_person.dart';

class ChatWidget extends StatelessWidget {
  final String userId;
  final Map<String, dynamic> data;
  const ChatWidget({super.key, required this.userId, required this.data});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListTile(
            onLongPress: () async {
              DialogManager.showChatOptionsPopup(context, data);
            },
            onTap: () async {
              final userData = await UserRepository().getUserMap();

              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) =>
                      ChatPagePerson(currentUser: userData, selectedUser: data),
                ),
              );
            },
            leading: Stack(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundImage: NetworkImage(data['photoUrl']),
                ),
                (data['status'])
                    ? const Positioned(
                        bottom: 0,
                        right: 0,
                        child: CircleAvatar(
                          backgroundColor: AppTheme.green,
                          radius: 5,
                        ),
                      )
                    : const SizedBox()
              ],
            ),
            title: Text(
              data['name'],
              style: Theme.of(context).textTheme.displayMedium,
            ),
            subtitle: FutureBuilder(
              future: MessagingRepository.getLastMessage(data['uid']),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final lastMessage = snapshot.data!.data();
                  if (lastMessage.containsKey('text') &&
                      lastMessage['text'] != null) {
                    // Display text message

                    return Row(
                      children: [
                        SizedBox(
                          width: 90,
                          child: Text(
                            '${lastMessage['text']}  ● ',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ),
                        Text(
                          '  ${timeago.format((lastMessage['sentTime'] as Timestamp).toDate(), clock: DateTime.now(), locale: 'en', allowFromNow: true)} ',
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(fontSize: 10),
                        )
                      ],
                    );
                  } else if (lastMessage.containsKey('photoUrl') &&
                      lastMessage['photoUrl'] != null) {
                    // Display image message
                    return Row(
                      children: [
                        const Icon(EvaIcons.image),
                        const SizedBox(width: 8), // Add some spacing
                        const Text("Photo"),
                        Text(timeago.format(
                            (lastMessage['sentTime'] as Timestamp).toDate(),
                            locale: 'en_short')),
                      ],
                    );
                  }
                }
                return const SizedBox();
              },
            )));
  }
}
