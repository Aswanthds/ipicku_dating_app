
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ipicku_dating_app/domain/messages/messages_bloc.dart';
import 'package:ipicku_dating_app/presentation/chatpage/call_history_page.dart';
import 'package:ipicku_dating_app/presentation/chatpage/widget/chat_widget_sep.dart';
import 'package:ipicku_dating_app/presentation/ui_utils/colors.dart';
import 'package:ipicku_dating_app/presentation/widgets/empty_list.dart';

class ChatPage extends StatefulWidget {


  const ChatPage({
    super.key,
  });

  @override
  State<ChatPage> createState() => _ChatPageState();
  static String route = '/chat_page';
}

class _ChatPageState extends State<ChatPage> {
  @override
  Widget build(BuildContext context) {
    BlocProvider.of<MessagesBloc>(context).add(GetChatList());
    
    return RefreshIndicator(
      displacement: 60,
      backgroundColor: AppTheme.white,
      color: AppTheme.blue,
      onRefresh: () async {
        BlocProvider.of<MessagesBloc>(context).add(GetChatList());
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Chats"),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const CallHistoryPage(),
                ));
              },
              icon: const Icon(Icons.phone),
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
              final data = state.userData;
              if (data.isNotEmpty) {
                return ListView.separated(
                    itemCount: state.userData.length,
                    shrinkWrap: true,
                    separatorBuilder: (context, index) => const Divider(),
                    itemBuilder: (context, index) {
                      return ChatWidgetInd(
                         selectedUserData: data[index]);
                    });
              }
              return const EmptyListPage(text: "No Chats here");
            }
            if (state is GetChatsLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }
}
