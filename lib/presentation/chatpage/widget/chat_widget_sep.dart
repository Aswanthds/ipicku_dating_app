import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:ipicku_dating_app/data/repositories/messaging_repository.dart';
import 'package:ipicku_dating_app/presentation/ui_utils/colors.dart';
import 'package:ipicku_dating_app/presentation/ui_utils/dialog_manager.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:ipicku_dating_app/data/repositories/user_repositories.dart';
import 'package:ipicku_dating_app/presentation/chatpage/widget/chat_person.dart';

class ChatWidgetInd extends StatelessWidget {
  const ChatWidgetInd({
    super.key,
    required this.selectedUserData,
    required this.userId,
  });
  final String userId;
  final Map<String, dynamic> selectedUserData;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppTheme.blue,
      margin: EdgeInsets.all(5),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: ListTile(
          onTap: () async {
            final userData = await UserRepository()
                .getUserMapAlongwithBloc(selectedUserData['uid']);
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => ChatPagePerson(
                    currentUser: userData, selectedUser: selectedUserData),
              ),
            );
          },
          leading: Stack(
            children: [
              (!selectedUserData['blocked'])
                  ? CircleAvatar(
                      radius: 30,
                      backgroundImage:
                          NetworkImage(selectedUserData['photoUrl']),
                    )
                  : CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.orange,
                      child: Center(
                          child: Text(
                        selectedUserData['name'].toString()[0],
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge
                            ?.copyWith(fontWeight: FontWeight.bold),
                      )),
                    ),
              (selectedUserData['status'] && !selectedUserData['blocked'])
                  ? const Positioned(
                      bottom: 0,
                      right: 10,
                      child: CircleAvatar(
                        backgroundColor: AppTheme.green,
                        radius: 5,
                      ),
                    )
                  : const SizedBox()
            ],
          ),
          title: Row(
            children: [
              Text(
                selectedUserData['name'],
                style: Theme.of(context).textTheme.displayMedium,
              ),
              SizedBox(
                width: 5,
              ),
              Wrap(
                direction: Axis.horizontal,
                children: [
                  (selectedUserData['muted'])
                      ? const Icon(EvaIcons.volumeOffOutline)
                      : const SizedBox(),
                ],
              )
            ],
          ),
          subtitle: (selectedUserData['blocked'] &&
                  selectedUserData['done_by'] != userId)
              ? const SizedBox()
              : FutureBuilder(
                  future: MessagingRepository.getLastMessage(
                      selectedUserData['uid']),
                  builder: (context, snapshot) {
                    //print(isBlocked['done_by'] == selectedUserData['uid']);
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
                              '  ${timeago.format(
                                (lastMessage['sentTime'] as Timestamp).toDate(),
                                clock: DateTime.now(),
                                locale: 'en',
                                allowFromNow: true,
                              )} ',
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
                            const SizedBox(width: 10),
                            Text(timeago.format(
                                (lastMessage['sentTime'] as Timestamp).toDate(),
                                locale: 'en_short')),
                          ],
                        );
                      }
                    }
                    return const SizedBox();
                  },
                ),
          trailing: IconButton(
              onPressed: () async {
                final userData = await UserRepository().getUserMap();
                final RenderBox renderBox =
                    context.findRenderObject() as RenderBox;
                final tapPosition = renderBox.localToGlobal(Offset.zero);
                DialogManager.showChatOptionsPopup(
                    context: context,
                    data: selectedUserData,
                    currentData: userData ?? {},
                    isMuted: selectedUserData['muted'] ?? false,
                    tapPosition: tapPosition,
                    isBlocked: selectedUserData['blocked'] ?? false);
              },
              icon: Icon(EvaIcons.moreHorizontalOutline))),
    );
  }
}
/*
 : (isBlocked != null && isBlocked == true)
                ? Text("Blcoked")

                   TextButton(
                onPressed: () async {
                  final userData = await UserRepository().getUserMap();
                  DialogManager.showChatOptionsPopup(
                      context,
                      selectedUserData,
                      userData ?? {},
                      selectedUserData['muted'] ?? false,
                      selectedUserData['blocked'] ?? false);
                },
                child: Text(' '))
*/