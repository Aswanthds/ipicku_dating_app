import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ipicku_dating_app/domain/messages/messages_bloc.dart';
import 'package:ipicku_dating_app/domain/video_chat/videochat_bloc.dart';
import 'package:ipicku_dating_app/presentation/widgets/empty_page.dart';
import 'package:timeago/timeago.dart';

class CallHistoryPage extends StatelessWidget {
  const CallHistoryPage({super.key});

  static final navigatorKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    BlocProvider.of<VideochatBloc>(context).add(
      GetVideoChatsList(),
    );
    return Scaffold(
      appBar: AppBar(
        title: const Text("Call History"),
      ),
      body: BlocBuilder<VideochatBloc, VideochatState>(
        builder: (context, state) {
          if (state is GetVideoChatsLoaded) {
            if (state.userData.isEmpty) {
              return const EmptyPageGif(text: "No Calls history");
            }
            return ListView.builder(
              itemCount: state.userData.length,
              itemBuilder: (context, index) =>
                  _buildCallWidget(context, state.userData[index]),
            );
          }
          if (state is GetChatsLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          return const SizedBox();
        },
      ),
    );
  }

  ListTile _buildCallWidget(BuildContext context, Map<String, dynamic> data) {
    String currentUserId = FirebaseAuth.instance.currentUser?.uid ?? "";

    bool isOutgoingCall = data['from'] == currentUserId;
    String callDirection = isOutgoingCall ? "Outgoing" : "Incoming";
    IconData callDirectionIcon =
        isOutgoingCall ? Icons.call_made_rounded : Icons.call_received_rounded;
    Color callDirectionColor = isOutgoingCall ? Colors.green : Colors.red;

    return ListTile(
      leading: CircleAvatar(
        radius: 30,
        backgroundImage:
            NetworkImage(isOutgoingCall ? data['toPhoto'] : data['fromPhoto']),
        backgroundColor: Colors.yellow,
      ),
      subtitle: Row(
        children: [
          Text(
            callDirection,
            style: Theme.of(context).textTheme.bodySmall,
          ),
          Icon(
            callDirectionIcon,
            color: callDirectionColor,
            size: 15,
          )
        ],
      ),
      title: Text(
        isOutgoingCall ? "${data['toName']}" : "${data['fromName']}",
        style: Theme.of(context).textTheme.displayMedium,
      ),
      trailing: Text(
        format((data['time'] as Timestamp).toDate(),locale: 'en_short',clock: DateTime.now()),
        style: Theme.of(context).textTheme.bodySmall,
      ),
    );
  }
}
