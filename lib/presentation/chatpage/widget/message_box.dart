import 'dart:io';

import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ipicku_dating_app/data/functions/profile_functions.dart';
import 'package:ipicku_dating_app/data/repositories/push_notifi_service.dart';
import 'package:ipicku_dating_app/domain/messaging/messaging_bloc.dart';
import 'package:ipicku_dating_app/presentation/ui_utils/colors.dart';
import 'package:ipicku_dating_app/presentation/ui_utils/constants.dart';

class UserMessageBox extends StatefulWidget {
  final Map<String, dynamic>? selectedUser, currentUser;
  final ScrollController controller;
  const UserMessageBox(
      {super.key,
      this.selectedUser,
      this.currentUser,
      required this.controller});

  @override
  State<UserMessageBox> createState() => _UserMessageBoxState();
}

class _UserMessageBoxState extends State<UserMessageBox> {
  final TextEditingController _msgController = TextEditingController();
  File? imageChat;
  FocusNode node = FocusNode();
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      decoration: const BoxDecoration(color: Colors.transparent),
      child: Row(
        children: [
          IconButton(
            icon: Icon(
              EvaIcons.cameraOutline,
              color: Theme.of(context).textTheme.bodySmall?.color,
            ),
            onPressed: () async {
              if (!widget.currentUser?['blocked']) {
                final image = await ProfileFunctions.pickImage();
                if (image != null) {
                  final croppedImage =
                      await ProfileFunctions.cropImage(File(image.path));

                  if (croppedImage != null) {
                    setState(() {
                      imageChat = File(croppedImage.path);
                    });
                     _onFormSubmitted();
                  }
                 
                  if (widget.selectedUser?['deviceToken'] != null &&
                      widget.selectedUser?['notifications_messages'] == true) {
                    PushNotificationService().sendPushMessage(
                        token: widget.selectedUser?['deviceToken'],
                        type: 'messages',
                        title: 'A new message',
                        body:
                            '${widget.currentUser?['name']} just messaged you');
                  }
                }
              } else {
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBarManager.userBlockedSnackbar(context));
              }
            },
          ),
          Expanded(
            child: TextFormField(
              controller: _msgController,
              focusNode: node,
              textAlign: TextAlign.start,
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderSide: BorderSide(
                          style: BorderStyle.solid,
                          color:
                              Theme.of(context).textTheme.displaySmall!.color ??
                                  AppTheme.white),
                      borderRadius:
                          const BorderRadius.all(Radius.circular(20)))),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send),
            onPressed: () {
              if (_msgController.text.isNotEmpty) {
                if (!widget.currentUser?['blocked'] ||
                    !widget.selectedUser?['blocked']) {
                  _onFormSubmitted();
                  FocusScope.of(context).unfocus();

                  if (widget.selectedUser?['deviceToken'] != null) {
                    bool shouldSendNotification =
                        widget.selectedUser?['notifications_messages'] ?? false;
                    bool isMuted = (widget.selectedUser?['muted'] ?? false);
                    debugPrint('$shouldSendNotification  => $isMuted');
                    if ((shouldSendNotification == false && isMuted == false) || !shouldSendNotification  && !isMuted ) {
                      PushNotificationService().sendPushMessage(
                        token: widget.selectedUser?['deviceToken'],
                        type: 'messages',
                        title: 'A new message',
                        body:
                            '${widget.currentUser?['name']} just messaged you',
                      );
                    }
                  }
                } else {
                  if (widget.selectedUser?['blocked'] &&
                      widget.selectedUser?['done_by'] ==
                          widget.currentUser?['uid']) {
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBarManager.userBlockedSnackbar(context));
                  }
                }
              }
            },
          ),
        ],
      ),
    );
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
    widget.controller.jumpTo(
      widget.controller.position.maxScrollExtent,
    );
  }

  @override
  void dispose() {
    _msgController.dispose();
    widget.controller.dispose();
    super.dispose();
  }
}
