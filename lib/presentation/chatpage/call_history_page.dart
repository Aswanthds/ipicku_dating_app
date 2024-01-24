import 'package:flutter/material.dart';

class CallHistoryPage extends StatelessWidget {
  const CallHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Call History"),
      ),
      body: ListView(
        children: const [
          ListTile(
            leading: CircleAvatar(
              radius: 30,
              backgroundImage: AssetImage(
                "assets/images/logo_dark.png",
              ),
              backgroundColor: Colors.yellow,
            ),
            subtitle: Row(
              children: [
                Text("Outgoing",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                    )),
                Icon(
                  Icons.call_made_rounded,
                  color: Colors.green,
                  size: 15,
                )
              ],
            ),
            title: Text("Devika",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                )),
            trailing: Text("12:30 PM",
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                )),
          )
        ],
      ),
    );
  }
}
