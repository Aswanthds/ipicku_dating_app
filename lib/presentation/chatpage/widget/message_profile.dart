import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ipicku_dating_app/data/functions/love_calculator_api.dart';
import 'package:ipicku_dating_app/data/functions/profile_functions.dart';
import 'package:ipicku_dating_app/domain/messages/messages_bloc.dart';
import 'package:ipicku_dating_app/presentation/chatpage/chatpage.dart';
import 'package:ipicku_dating_app/presentation/chatpage/widget/chat_person.dart';
import 'package:ipicku_dating_app/presentation/chatpage/widget/lovepercantage.dart';
import 'package:ipicku_dating_app/presentation/homepage/progfilepage.dart';
import 'package:ipicku_dating_app/presentation/profile/user_profile/image_preview.dart';
import 'package:ipicku_dating_app/presentation/ui_utils/constants.dart';

class MessageProfilePage extends StatefulWidget {
  final Map<String, dynamic> userDataA, userDataB;

  const MessageProfilePage(
      {super.key, required this.userDataA, required this.userDataB});

  @override
  State<MessageProfilePage> createState() => _MessageProfilePageState();
}

class _MessageProfilePageState extends State<MessageProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _profileIcon(context),
          const SizedBox(
            height: 10,
          ),
          BlocBuilder<MessagesBloc, MessagesState>(
              bloc: BlocProvider.of<MessagesBloc>(context),
              builder: (context, state) {
                if (state is GetChatsLoaded) {
                  return _actionWidgets(context);
                }
                if (state is GetChatsLoading) {
                  return const Center(
                      child: SizedBox(
                    height: 60,
                  ));
                }
                return const SizedBox();
              }),
          Center(
            child: LovePercentageWidget(
              percentage: LoveCalculatorAPi.loveCalculator(
                  widget.userDataA, widget.userDataB),
            ),
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Media",
              style: Theme.of(context).textTheme.displayLarge,
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: FutureBuilder<List<String>>(
                future: ProfileFunctions.showImages(
                    widget.userDataA['uid'], widget.userDataB['uid']),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data != null && snapshot.data!.isNotEmpty) {
                      return GridView.builder(
                        itemCount: snapshot.data?.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3, crossAxisSpacing: 2.0),
                        itemBuilder: (context, index) => GestureDetector(
                            onTap: () =>
                                Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => ImagePreviewPage(
                                      imageUrl: snapshot.data![index]),
                                )),
                            child: Image.network(snapshot.data![index])),
                      );
                    }
                    return const Center(
                      child: Text("No data found"),
                    );
                  }
                  return SizedBox();
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Row _actionWidgets(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        IconButton(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => UserProfileBottomSheet(
                      data: widget.userDataB,
                      userid: widget.userDataA['uid'],
                      isMyPick: true)));
            },
            icon: Column(
              children: [
                const Icon(
                  EvaIcons.personOutline,
                  size: 40,
                ),
                Text(
                  "Profile",
                  style: Theme.of(context).textTheme.bodyLarge,
                )
              ],
            )),
        IconButton(
            onPressed: () {
              if (widget.userDataB['muted']) {
                BlocProvider.of<MessagesBloc>(context).add(
                    MuteUser(value: false, userId: widget.userDataB['uid']));
                //SnackBarManager
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBarManager.userUnblocked(context),
                );
              } else {
                BlocProvider.of<MessagesBloc>(context).add(
                    MuteUser(value: true, userId: widget.userDataB['uid']));
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBarManager.userBlockedSnackbar(context),
                );
              }
              Navigator.pop(context);
            },
            icon: Column(
              children: [
                Icon(
                  widget.userDataB['muted']
                      ? EvaIcons.bellOffOutline
                      : EvaIcons.bellOutline,
                  size: 40,
                ),
                Text(
                  "Mute",
                  style: Theme.of(context).textTheme.bodyLarge,
                )
              ],
            )),
        IconButton(
            onPressed: () {
              if (widget.userDataB['blocked']) {
                BlocProvider.of<MessagesBloc>(context).add(
                    BlocUser(value: false, userId: widget.userDataB['uid']));
                //SnackBarManager
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBarManager.userUnblocked(context),
                );
              } else {
                BlocProvider.of<MessagesBloc>(context).add(
                    BlocUser(value: true, userId: widget.userDataB['uid']));
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBarManager.userBlockedSnackbar(context),
                );
              }
              Navigator.pop(context);
              Navigator.pop(context);
            },
            icon: Column(
              children: [
                const Icon(
                  EvaIcons.alertTriangle,
                  size: 40,
                ),
                Text(
                  "Block User",
                  style: Theme.of(context).textTheme.bodyLarge,
                )
              ],
            ))
      ],
    );
  }

  Center _profileIcon(BuildContext context) {
    return Center(
      child: Wrap(
        direction: Axis.vertical,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          CircleAvatar(
            backgroundImage: NetworkImage(widget.userDataB['photoUrl']),
            radius: 50,
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            '${widget.userDataB['name']}',
            style: Theme.of(context).textTheme.displayLarge,
          ),
        ],
      ),
    );
  }
}
