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
        children: [
          ListTile(
            leading: const CircleAvatar(
              radius: 30,
              backgroundImage: AssetImage(
                "assets/images/logo_dark.png",
              ),
              backgroundColor: Colors.yellow,
            ),
            subtitle: Row(
              children: [
                Text(
                  "Outgoing",
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const Icon(
                  Icons.call_made_rounded,
                  color: Colors.green,
                  size: 15,
                )
              ],
            ),
            title: Text(
              "Devika",
              style: Theme.of(context).textTheme.displayMedium,
            ),
            trailing: Text(
              "12:30 PM",
              style: Theme.of(context).textTheme.bodySmall,
            ),
          )
        ],
      ),
    );
  }
}
