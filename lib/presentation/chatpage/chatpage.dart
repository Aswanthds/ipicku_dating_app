import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatelessWidget {
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Chats"),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(EvaIcons.phoneCall),
          ),
        ],
      ),
      body: Column(children: [
        SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List<Widget>.generate(
                  5,
                  (index) => Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CircleAvatar(
                          radius: 40,
                          backgroundColor: Colors.accents[index],
                        ),
                      )),
            )),
        Expanded(
          child: ListView.builder(
            itemCount: 5,
            itemBuilder: (context, index) => ListTile(
              onTap: () {},
              leading: CircleAvatar(
                  radius: 20, backgroundColor: Colors.accents[index]),
              title: Text("Name ${index + 1}"),
              subtitle: const Text("hii"),
              trailing: Text("9:0${index + 1} AM"),
            ),
          ),
        ),
      ]),
    );
  }
}
