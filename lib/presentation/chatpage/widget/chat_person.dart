import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ipicku_dating_app/domain/messaging/messaging_bloc.dart';
import 'package:ipicku_dating_app/presentation/chatpage/widget/chat_person_appbar_title.dart';
import 'package:ipicku_dating_app/presentation/chatpage/widget/message_box.dart';
import 'package:ipicku_dating_app/presentation/chatpage/widget/message_bubble.dart';
import 'package:ipicku_dating_app/presentation/chatpage/widget/video_call_page.dart';
import 'package:ipicku_dating_app/presentation/ui_utils/constants.dart';

class ChatPagePerson extends StatefulWidget {
  final Map<String, dynamic>? selectedUser, currentUser;
  const ChatPagePerson({super.key, this.selectedUser, this.currentUser});

  @override
  State<ChatPagePerson> createState() => _ChatPagePersonState();
}

class _ChatPagePersonState extends State<ChatPagePerson> {
  final ScrollController _scrollController = ScrollController();
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
        leading: IconButton(
          icon: const Icon(EvaIcons.arrowIosBack),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: MessagePersonAppBarTitle(widget: widget, lastActive: lastActive),
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
                  return StreamBuilder(
                    stream: stream,
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return Text("Error ${snapshot.error}");
                      }
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      return ListView(
                        controller: _scrollController,
                        children: snapshot.data!.docs
                            .map((e) => MessageWidget(
                                  data: e,
                                  currentUSer: widget.currentUser ?? {},
                                  selectedUSer: widget.selectedUser ?? {},
                                ))
                            .toList(),
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
            ),
          ));
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
