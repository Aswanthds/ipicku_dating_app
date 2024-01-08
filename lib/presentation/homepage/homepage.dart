import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:ipicku_dating_app/presentation/chatpage/chatpage.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const ChatPage()));
              },
              icon: const Icon(EvaIcons.messageCircleOutline))
        ],
      ),
      body: Stack(
        children: [
          Center(
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Container(
                height: size.height,
                width: size.width - 50,
                decoration: BoxDecoration(
                  color: Colors.black26,
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(
                  onPressed: () {},
                  icon: const Icon(EvaIcons.slash),
                  color: Colors.red,
                  iconSize: 30,
                ),
                IconButton(
                  onPressed: () {},
                  icon: const ImageIcon(
                    AssetImage('assets/images/logo_light.png'),
                  ),
                  iconSize: 50,
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.report_gmailerrorred_outlined,
                  ),
                  iconSize: 30,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
