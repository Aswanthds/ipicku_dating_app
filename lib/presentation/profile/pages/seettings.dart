import 'package:flutter/material.dart';
import 'package:ipicku_dating_app/constants.dart';
import 'package:ipicku_dating_app/presentation/profile/widgets/age_pref_selector.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _enableListTile("Hide me from discovery"),
          _ageListTile(context),
          _enableListTile("Region Preference"),
          const Padding(
            padding: EdgeInsets.only(
              left: 15.0,
              top: 10,
            ),
            child: Text(
              "Push Notifications",
              style: TextStyle(
                color: Colors.black54,
                fontSize: 21,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          _enableListTile("Likes"),
          _enableListTile("Picks"),
          _enableListTile("Messgaes"),
          _enableListTile("Recommendations"),
          const Padding(
            padding: EdgeInsets.only(
              left: 15.0,
              top: 10,
            ),
            child: Text(
              "Theme",
              style: TextStyle(
                color: Colors.black54,
                fontSize: 21,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          _enableListTile("Dark Theme"),
        ],
      ),
    );
  }

  ListTile _ageListTile(BuildContext context) {
    return ListTile(
      onTap: () {
        showDialog(
            context: context, builder: (ctx) => const AgeSelectionWidget());
      },
      title: const Text(
        "Age Preference",
      ),
      trailing: SizedBox(
        width: 150,
        child: Wrap(
          direction: Axis.horizontal,
          children: [
            ageTextbox('18'),
            const SizedBox(
              width: 10,
            ),
            ageTextbox('25'),
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
          child: Text(
        text,
        style: const TextStyle(
          color: AppTheme.kPrimary,
          fontSize: 18,
        ),
      )),
    );
  }

  ListTile _enableListTile(String text) {
    return ListTile(
      title: Text(
        text,
      ),
      trailing: Switch(
        value: true,
        onChanged: (value) {},
        splashRadius: 1.5,
        activeColor: AppTheme.white,
        activeTrackColor: AppTheme.kPrimary,
      ),
    );
  }
}
