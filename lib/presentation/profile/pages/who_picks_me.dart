import 'package:flutter/material.dart';
import 'package:ipicku_dating_app/constants.dart';

class WhoPicksMePage extends StatelessWidget {
  const WhoPicksMePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Who Picks ME ?"),
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
