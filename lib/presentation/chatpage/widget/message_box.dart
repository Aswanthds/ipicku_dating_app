import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ipicku_dating_app/data/functions/profile_functions.dart';
import 'package:ipicku_dating_app/data/repositories/push_notifi_service.dart';
import 'package:ipicku_dating_app/domain/messaging/messaging_bloc.dart';
import 'package:ipicku_dating_app/presentation/ui_utils/colors.dart';
import 'package:ipicku_dating_app/presentation/ui_utils/constants.dart';

class UserMessageBox extends StatefulWidget {
  final Map<String, dynamic>? selectedUser, currentUser;
  final ScrollController controller;

  const UserMessageBox({
    super.key,
    required this.selectedUser,
    required this.controller,
    this.currentUser,
  });

  @override
  State<UserMessageBox> createState() => _UserMessageBoxState();
}

class _UserMessageBoxState extends State<UserMessageBox> {
  final TextEditingController _msgController = TextEditingController();
  File? imageChat;
  FocusNode node = FocusNode();
  int _maxLines = 1; // Initial number of lines
  final int _maxLength = 1000; // Set the maximum message length

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      decoration: const BoxDecoration(color: Colors.transparent),
      child: Row(
        children: [
          IconButton(
            icon: Icon(
              Icons.camera_enhance,
              color: Theme.of(context).textTheme.displayMedium?.color,
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
            child: TextField(
              controller: _msgController,
              focusNode: node,
              textAlign: TextAlign.start,
              maxLines: _maxLines,
              inputFormatters: [_textInputFormatter(maxLength: _maxLength)],
              onChanged: (text) {
                if (text.contains('\n')) {
                  setState(() {
                    _maxLines = _maxLines < 5
                        ? _maxLines + 1
                        : 5; // Limit maxLines to 5
                  });
                }
              },
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(horizontal: 8.0),
                border: OutlineInputBorder(
                  borderSide: BorderSide(
                    style: BorderStyle.solid,
                    color: Theme.of(context).textTheme.displaySmall!.color ??
                        AppTheme.white,
                  ),
                  borderRadius: const BorderRadius.all(Radius.circular(20)),
                ),
              ),
              scrollPhysics: const NeverScrollableScrollPhysics(),
            ),
          ),
          IconButton(
            icon: Icon(Icons.send,
                color: Theme.of(context).textTheme.displayMedium?.color),
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
                    if ((shouldSendNotification == false && isMuted == false) ||
                        !shouldSendNotification && !isMuted) {
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

  TextInputFormatter _textInputFormatter({int maxLength = 1000}) {
    return LengthLimitingTextInputFormatter(maxLength);
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
