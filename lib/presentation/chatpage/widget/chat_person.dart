import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ipicku_dating_app/data/repositories/messaging_repository.dart';
import 'package:ipicku_dating_app/domain/messaging/messaging_bloc.dart';
import 'package:ipicku_dating_app/domain/video_chat/videochat_bloc.dart';
import 'package:ipicku_dating_app/presentation/chatpage/widget/chat_person_appbar_title.dart';
import 'package:ipicku_dating_app/presentation/chatpage/widget/date_separator.dart';
import 'package:ipicku_dating_app/presentation/chatpage/widget/message_box.dart';
import 'package:ipicku_dating_app/presentation/chatpage/widget/message_bubble.dart';
import 'package:ipicku_dating_app/presentation/chatpage/video_call_page.dart';
import 'package:ipicku_dating_app/presentation/chatpage/widget/message_profile.dart';
import 'package:ipicku_dating_app/presentation/ui_utils/colors.dart';
import 'package:ipicku_dating_app/presentation/ui_utils/constants.dart';
import 'package:ipicku_dating_app/presentation/widgets/empty_list.dart';

class ChatPagePerson extends StatefulWidget {
  final Map<String, dynamic>? selectedUser, currentUser;
  final bool isblocked;
  const ChatPagePerson({super.key, this.selectedUser, this.currentUser, required this.isblocked});

  @override
  State<ChatPagePerson> createState() => _ChatPagePersonState();

}
 
class _ChatPagePersonState extends State<ChatPagePerson> {
  
  final ScrollController _scrollController = ScrollController();
  @override
  void initState() {
    super.initState();
    // MessagingRepository.updateUserSeen(widget.selectedUser?['uid']);
  }

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<MessagingBloc>(context).add(
      GetMessages(
          userId: widget.currentUser?['uid'],
          recieverId: widget.selectedUser?['uid']),
    );

    final lastActive =
        (widget.selectedUser?['lastActive'] as Timestamp).toDate();

    return Scaffold(
      appBar: AppBar(
        backgroundColor:
            Theme.of(context).appBarTheme.backgroundColor != Colors.white
                ? AppTheme.redAccent.withOpacity(0.5)
                : AppTheme.white,
        leading: IconButton(
          icon: const Icon(EvaIcons.arrowIosBack),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: InkWell(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => MessageProfilePage(
                  userDataA: widget.currentUser ?? {},
                  userDataB: widget.selectedUser ?? {},
                ),
              ));
            },
            child: MessagePersonAppBarTitle(
                widget: widget, lastActive: lastActive)),
        actions: [
          //callButton(),
          if (widget.selectedUser?['blocked'] &&
                  widget.selectedUser?['done_by'] ==
                      widget.currentUser?['uid'] ||
              widget.currentUser?['blocked'] &&
                  widget.currentUser?['done_by'] == widget.selectedUser?['uid'])
            IconButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBarManager.userBlockedSnackbar(context));
                },
                icon: const Icon(EvaIcons
                    .videoOffOutline)) // Placeholder widget when blocked
          else
            _callInitButton(context),
          //   callButton()
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(children: [
          Expanded(
            child: BlocBuilder<MessagingBloc, MessagingState>(
              builder: (context, state) {
                if (state is MessageStreamLoaded) {
                  final stream = state.messages;
                  DateTime? lastDate; // Keep track of the last date

                  return StreamBuilder(
                    stream: stream,
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return Text("Error ${snapshot.error}");
                      }
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      final messages = snapshot.data!.docs;

                      if (messages.isEmpty) {
                        return const EmptyListPage(text: "No Chats , Say HII");
                      }
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        // Scroll to the end after inserting a new message
                        _scrollController.animateTo(
                          _scrollController.position.maxScrollExtent,
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      });
                      return ListView.builder(
                        controller: _scrollController,
                        itemCount: messages.length,
                        itemBuilder: (context, index) {
                          final message = messages[index];
                          final sentTime =
                              (message['sentTime'] as Timestamp).toDate();
                          final currentDate = DateTime(
                              sentTime.year, sentTime.month, sentTime.day);
                          if (message.exists &&
                              message['senderId'] !=
                                  widget.currentUser?['uid']) {
                            MessagingRepository.updateUserSeen(
                                widget.selectedUser?['uid'], message.id);
                          }
                          Widget messageWidget = MessageWidget(
                            data: message,
                            currentUSer: widget.currentUser ?? {},
                            selectedUSer: widget.selectedUser ?? {},
                          );

                          // Check if the date has changed since the last message
                          if (lastDate == null || lastDate != currentDate) {
                            messageWidget = Column(
                              crossAxisAlignment: (message['senderId'] ==
                                      widget.currentUser?['uid'])
                                  ? CrossAxisAlignment.end
                                  : CrossAxisAlignment.start,
                              children: [
                                // Insert date separator here
                                DateSeparatorWidget(date: currentDate),
                                // Add the message widget
                                messageWidget,
                              ],
                            );
                          }

                          lastDate = currentDate; // Update the last date

                          return messageWidget;
                        },
                      );
                    },
                  );
                }

                return const SizedBox();
              },
            ),
          ),
          ((widget.currentUser?['blocked'] || widget.selectedUser?['blocked']))
              ? SizedBox(
                  height: 50,
                  child: Text(
                    'You cant message this user !!',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                )
              : UserMessageBox(
                  controller: _scrollController,
                  currentUser: widget.currentUser,
                  selectedUser: widget.selectedUser,
                )
        ]),
      ),
    );
  }

  IconButton _callInitButton(BuildContext context) {
    return IconButton(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => PrebuiltCallPage(
              userID: widget.selectedUser?['uid'],
              name: widget.currentUser?['name'],
            ),
          ));
          BlocProvider.of<VideochatBloc>(context).add(SendVideoChatData(
              selectedUser: widget.selectedUser?['uid'], token: 'call_id'));
          BlocProvider.of<MessagingBloc>(context).add(
            SendMessageEvent(
              imagel: null,
              contnet: "A Video chat is started click this to join",
              recieverId: widget.selectedUser?['uid'],
            ),
          );
        },
        icon: const Icon(EvaIcons.videoOutline));
  }
}
