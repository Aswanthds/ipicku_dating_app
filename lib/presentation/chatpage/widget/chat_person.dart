import 'package:flutter/material.dart';
import 'package:ipicku_dating_app/constants.dart';
import 'package:ipicku_dating_app/presentation/chatpage/widget/video_call_page.dart';

class ChatPagePerson extends StatelessWidget {
  const ChatPagePerson({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Name 1'),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const VideoChatPage(),
                ));
              },
              icon: const Icon(Icons.video_chat))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                reverse: true, // To show messages from bottom to top
                children: const [
                  // Placeholder for received message
                  MessageWidget(
                    message: 'Hi.',
                    isSentByMe: false,
                  ),
                  // Placeholder for sent message
                  MessageWidget(
                    message: 'Hello!',
                    isSentByMe: true,
                  ),
                  // Add more messages as needed
                ],
              ),
            ),
            // Input area for typing and sending messages
            SizedBox(
              height: 40,
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.camera_alt),
                    onPressed: () {
                      // Implement sending message logic here
                    },
                  ),
                  const Expanded(
                    child: TextField(
                      textAlign: TextAlign.start,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20)))),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.mic),
                    onPressed: () {
                      // Implement sending message logic here
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.send),
                    onPressed: () {
                      // Implement sending message logic here
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
}

class MessageWidget extends StatelessWidget {
  final String message;
  final bool isSentByMe;

  const MessageWidget({
    super.key,
    required this.message,
    required this.isSentByMe,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isSentByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isSentByMe ? AppTheme.blue : AppTheme.grey,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          message,
          style: const TextStyle(color: AppTheme.white),
        ),
      ),
    );
  }
}
