import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ipicku_dating_app/domain/messages/messages_bloc.dart';
import 'package:ipicku_dating_app/presentation/chatpage/call_history_page.dart';
import 'package:ipicku_dating_app/presentation/chatpage/widget/chat_page_widget.dart';

class ChatPage extends StatefulWidget {
  final String userid;

  const ChatPage({
    super.key,
    required this.userid,
  });

  @override
  State<ChatPage> createState() => _ChatPageState();
  static String route = '/chat_page';
}

class _ChatPageState extends State<ChatPage> {
  @override
  Widget build(BuildContext context) {
    BlocProvider.of<MessagesBloc>(context).add(GetChatList());
    return Scaffold(
      appBar: AppBar(
        title: const Text("Chats"),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const CallHistoryPage(),
              ));
            },
            icon: const Icon(EvaIcons.phoneCall),
          ),
        ],
      ),
      body: BlocBuilder<MessagesBloc, MessagesState>(
        bloc: BlocProvider.of<MessagesBloc>(context),
        builder: (context, state) {
          if (state is MessagesInitial) {
            BlocProvider.of<MessagesBloc>(context).add(GetChatList());
          }
          if (state is GetChatsLoaded) {
            return ListView.builder(
                itemCount: state.userData.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  final data = state.userData;
                  debugPrint(data[index]['name']);

                  return ChatWidget(userId: widget.userid, data: data[index]);
                });
          }
          if (state is GetChatsLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          return const SizedBox();
        },
      ),
    );
  }
}
