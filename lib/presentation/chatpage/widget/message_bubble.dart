import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:ipicku_dating_app/domain/messaging/messaging_bloc.dart';
import 'package:ipicku_dating_app/domain/video_chat/videochat_bloc.dart';
import 'package:ipicku_dating_app/presentation/profile/user_profile/image_preview.dart';

import 'package:ipicku_dating_app/presentation/ui_utils/colors.dart';
import 'package:ipicku_dating_app/presentation/chatpage/widget/video_call_page.dart';

class MessageWidget extends StatefulWidget {
  final DocumentSnapshot data;
  final Map<String, dynamic> selectedUSer, currentUSer;

  const MessageWidget({
    super.key,
    required this.data,
    required this.selectedUSer,
    required this.currentUSer,
  });

  @override
  State<MessageWidget> createState() => _MessageWidgetState();
}

class _MessageWidgetState extends State<MessageWidget> {
  bool calledOnce = false;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    final data = widget.data.data() as Map<String, dynamic>;
    final isCurrentUser =
        widget.data['senderId'] == FirebaseAuth.instance.currentUser?.uid;

    return GestureDetector(
      onLongPress: () {
        if (isCurrentUser) {
          showDialog(
              context: context,
              builder: (context) => AlertDialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                          0), // Set radius to 0 for a rectangular shape
                    ),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Delete Message?',
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Are you sure you want to delete this message?',
                          style: Theme.of(context).textTheme.displaySmall,
                        ),
                      ],
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop(); // Close the dialog
                        },
                        child: Text(
                          'Cancel',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          BlocProvider.of<MessagingBloc>(context).add(
                              DeleteMessage(
                                  userId: widget.currentUSer['uid'],
                                  recieverId: widget.selectedUSer['uid'],
                                  msgId: widget.data.id));
                          Navigator.of(context).pop();
                        },
                        child: const Text(
                          'Delete',
                          style: TextStyle(
                            color: Colors
                                .red, // You can customize the color as needed
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ));
        }
      },
      child: Column(
        crossAxisAlignment:
            isCurrentUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(size.height * 0.01),
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: size.width * 0.7),
              child: Container(
                decoration: BoxDecoration(
                  color:
                      isCurrentUser ? AppTheme.primaryColor : AppTheme.grey300,
                  borderRadius: isCurrentUser
                      ? BorderRadius.only(
                          topLeft: Radius.circular(size.height * 0.02),
                          topRight: Radius.circular(size.height * 0.02),
                          bottomLeft: Radius.circular(size.height * 0.02),
                        )
                      : BorderRadius.only(
                          topLeft: Radius.circular(size.height * 0.02),
                          topRight: Radius.circular(size.height * 0.02),
                          bottomRight: Radius.circular(size.height * 0.02),
                        ),
                ),
                padding: EdgeInsets.all(size.height * 0.01),
                child: buildMessageContent(
                  data,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildMessageContent(Map<String, dynamic> data) {
    final size = MediaQuery.of(context).size;

    final isCurrentUser =
        widget.data['senderId'] == FirebaseAuth.instance.currentUser?.uid;
    if (data['text'] != null &&
        data['text'] != 'A Video chat is started click this to join') {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisSize: MainAxisSize.min, // Ensure minimum horizontal space
        children: [
          Flexible(
            child: Container(
              decoration: BoxDecoration(
                color: isCurrentUser ? AppTheme.primaryColor : AppTheme.grey300,
                borderRadius: isCurrentUser
                    ? BorderRadius.only(
                        topLeft: Radius.circular(size.height * 0.02),
                        topRight: Radius.circular(size.height * 0.02),
                        bottomLeft: Radius.circular(size.height * 0.02),
                      )
                    : BorderRadius.only(
                        topLeft: Radius.circular(size.height * 0.02),
                        topRight: Radius.circular(size.height * 0.02),
                        bottomRight: Radius.circular(size.height * 0.02),
                      ),
              ),
              padding: EdgeInsets.all(size.height * 0.01),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    data['text'] ?? '',
                    style: TextStyle(
                      color: (data['senderId'] ==
                              FirebaseAuth.instance.currentUser?.uid)
                          ? Colors.white
                          : Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(size.height * 0.01),
            child: Text(
              DateFormat.jm().format((data['sentTime'] as Timestamp).toDate()),
              style: Theme.of(context).textTheme.bodySmall!.copyWith(
                    fontSize: 8,
                    color: (data['senderId'] ==
                            FirebaseAuth.instance.currentUser?.uid)
                        ? Colors.white
                        : Colors.black,
                  ),
            ),
          ),
        ],
      );
    } else if (data['type'] == 'image') {
      return Stack(
        alignment: Alignment.bottomRight,
        children: [
          ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.7,
              maxHeight: MediaQuery.of(context).size.width * 0.8,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(
                  MediaQuery.of(context).size.height * 0.02),
              child: GestureDetector(
                  onTap: () => Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) =>
                            ImagePreviewPage(imageUrl: data['photoUrl']),
                      )),
                  child: Image.network(data['photoUrl'])),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(size.height * 0.01),
            child: Text(
              DateFormat.jm().format((data['sentTime'] as Timestamp).toDate()),
              style: Theme.of(context).textTheme.bodySmall!.copyWith(
                    color: (data['senderId'] ==
                            FirebaseAuth.instance.currentUser?.uid)
                        ? Colors.white
                        : Colors.black,
                  ),
            ),
          ),
        ],
      );
    } else if (data['text'] == 'A Video chat is started click this to join') {
      return ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.7,
          maxHeight: 80,
        ),
        child: ListTile(
          onTap: () {
            if (!calledOnce ||
                (widget.selectedUSer['blocked'] &&
                    widget.selectedUSer['done_by'] ==
                        widget.currentUSer['uid'])) {
              if (widget.selectedUSer['uid'] !=
                  FirebaseAuth.instance.currentUser!.uid) {
                BlocProvider.of<VideochatBloc>(context).add(SendVideoChatData(
                  token: 'call_id',
                  selectedUser: widget.selectedUSer['uid'],
                ));
              }
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => PrebuiltCallPage(
                  userID: widget.selectedUSer['uid'],
                ),
              ));

              setState(() {
                calledOnce = true;
              });
            }
          },
          leading: Icon(
            EvaIcons.video,
            color: (data['senderId'] == FirebaseAuth.instance.currentUser?.uid)
                ? Colors.white
                : Colors.black,
            size: 15,
          ),
          title: Text(
            "Video Chat",
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: (data['senderId'] ==
                          FirebaseAuth.instance.currentUser?.uid)
                      ? Colors.white
                      : Colors.black,
                ),
          ),
          trailing: Padding(
            padding: EdgeInsets.only(left: size.height * 0.01),
            child: Text(
              DateFormat.jm().format((data['sentTime'] as Timestamp).toDate()),
              style: Theme.of(context).textTheme.bodySmall!.copyWith(
                    fontSize: 8,
                    color: (data['senderId'] ==
                            FirebaseAuth.instance.currentUser?.uid)
                        ? Colors.white
                        : Colors.black,
                  ),
            ),
          ),
        ),
      );
    } else {
      return const SizedBox();
    }
  }
}
