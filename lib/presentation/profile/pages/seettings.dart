import 'package:flutter/material.dart';
import 'package:ipicku_dating_app/constants.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
      ),
      body: Column(
        children: [
          _enableListTile("Hide me from discovery"),
          _ageListTile(),
          _enableListTile("Region Preference"),
        ],
      ),
    );
  }

  ListTile _ageListTile() {
    return ListTile(
      title: const Text(
        "Age",
        style: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      trailing: SizedBox(
        width: 150,
        child: Wrap(
          direction: Axis.horizontal,
          children: [
            ageTextbox('Min'),
            const SizedBox(
              width: 10,
            ),
            ageTextbox('Max'),
          ],
        ),
      ),
    );
  }

  Container ageTextbox(String text) {
    return Container(
      width: 60,
      height: 35,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: const Color(0xffd9d9d9),
      ),
      child: Center(
        child: TextField(
          keyboardType: TextInputType.number,
          textAlign: TextAlign.center,
          decoration: InputDecoration(
            hintText: text,
            contentPadding: const EdgeInsets.all(0),
            border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(10),
              ),
            ),
            hintStyle: const TextStyle(color: Colors.black),
          ),
        ),
      ),
    );
  }

  ListTile _enableListTile(String text) {
    return ListTile(
      title: Text(
        text,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      trailing: Switch(
        value: true,
        onChanged: (value) {},
        splashRadius: 1.5,
        activeColor: Colors.white,
        activeTrackColor: kPrimary,
      ),
    );
  }
}
