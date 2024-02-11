import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ipicku_dating_app/data/functions/profile_functions.dart';
import 'package:ipicku_dating_app/data/repositories/push_notifi_service.dart';
import 'package:ipicku_dating_app/domain/messaging/messaging_bloc.dart';
import 'package:ipicku_dating_app/presentation/chatpage/widget/message_bubble.dart';
import 'package:ipicku_dating_app/presentation/ui_utils/colors.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:ipicku_dating_app/presentation/chatpage/widget/video_call_page.dart';

class ChatPagePerson extends StatefulWidget {
  final Map<String, dynamic>? selectedUser, currentUser;
  const ChatPagePerson({super.key, this.selectedUser, this.currentUser});

  @override
  State<ChatPagePerson> createState() => _ChatPagePersonState();
}

class _ChatPagePersonState extends State<ChatPagePerson> {
  final TextEditingController _msgController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  XFile? imageChat;

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
        title: Row(
          children: [
            Stack(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundImage:
                      NetworkImage(widget.selectedUser?['photoUrl']),
                ),
                (widget.selectedUser?['status'])
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
            const SizedBox(
              width: 20,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.selectedUser?['name'],
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge
                      ?.copyWith(fontSize: 20),
                ),
                (widget.selectedUser?['status'] == false &&
                        lastActive != DateTime.now())
                    ? Text(
                        'Active ${timeago.format(lastActive)}',
                        style: Theme.of(context).textTheme.bodySmall,
                      )
                    : Text(
                        'Active now',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppTheme.green, fontWeight: FontWeight.bold),
                      )
              ],
            ),
          ],
        ),
        actions: [_callInitButton(context)],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
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
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
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
            SizedBox(
              height: 50,
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.camera_alt),
                    onPressed: () async {
                      final image = await ProfileFunctions.pickImage();
                      if (image != null) {
                        final croppedImage =
                            await ProfileFunctions.cropImage(File(image.path));

                        if (croppedImage != null) {
                          setState(() {
                            imageChat = XFile(croppedImage.path);
                          });
                        }
                        _onFormSubmitted();
                      }
                    },
                  ),
                  Expanded(
                    child: TextFormField(
                      controller: _msgController,
                      textAlign: TextAlign.start,
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20)))),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.send),
                    onPressed: () {
                      if (_msgController.text.isNotEmpty) {
                        _onFormSubmitted();
                        if (widget.selectedUser?['deviceToken'] != null &&
                            widget.selectedUser?['notifications_messages'] ==
                                true) {
                          PushNotificationService().sendPushMessage(
                              token: widget.selectedUser?['deviceToken'],
                              type: 'messages',
                              title: 'A new message',
                              body:
                                  '${widget.currentUser?['name']} just messaged you');
                        }
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
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
        icon: const Icon(Icons.video_chat));
  }

  void _onFormSubmitted() {
    debugPrint("Message Submitted");

    if (_msgController.text.isNotEmpty) {
      BlocProvider.of<MessagingBloc>(context).add(
        SendMessageEvent(
          imagel: null,
          contnet: _msgController.text.trim(),
          recieverId: widget.selectedUser?['uid'],
        ),
      );
    } else {
      BlocProvider.of<MessagingBloc>(context).add(
        SendMessageEvent(
          imagel: imageChat,
          contnet: null,
          recieverId: widget.selectedUser?['uid'],
        ),
      );
    }
    _msgController.clear();
    _scrollController.jumpTo(
      _scrollController.position.maxScrollExtent,
    );
  }

  @override
  void dispose() {
    _msgController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}
