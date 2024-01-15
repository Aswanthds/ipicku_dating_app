import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';

class ContactUsPage extends StatelessWidget {
  const ContactUsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Contact Us"),
      ),
      body: ListView(children: const [
        ListTile(
          leading: Icon(
            Icons.report_gmailerrorred_sharp,
          ),
          title: Text("Report a problem"),
        ),
        ListTile(
          leading: Icon(
            Icons.feedback_outlined,
          ),
          title: Text("Send Feedback"),
        ),
        ListTile(
          leading: Icon(
            EvaIcons.shareOutline,
          ),
          title: Text("Share app"),
        ),
        ListTile(
          leading: Icon(
            EvaIcons.infoOutline,
          ),
          title: Text("About App"),
        ),
      ]),
    );
  }
}
