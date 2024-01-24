import 'package:flutter/material.dart';
import 'package:ipicku_dating_app/constants.dart';

class MyPicksPage extends StatelessWidget {
  const MyPicksPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Picks"),
      ),
      body: ListView(children: [
        ListTile(
          title: const Text("Name"),
          subtitle: const Text("picked on"),
          leading: const CircleAvatar(
            backgroundColor: AppTheme.kPrimary,
          ),
          trailing: IconButton(
            onPressed: () {},
            icon: const Icon(Icons.close),
          ),
        )
      ]),
    );
  }
}
