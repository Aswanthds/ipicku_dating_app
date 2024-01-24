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
      body: ListView(children: [
        const ListTile(
          leading: Icon(
            Icons.report_gmailerrorred_sharp,
          ),
          title: Text("Report a problem"),
        ),
        ListTile(
          onTap: () {
// Navigator.of(context).push(MaterialPageRoute(builder: (context) => ,))
          },
          leading: const Icon(
            Icons.feedback_outlined,
          ),
          title: const Text("Send Feedback"),
        ),
        const ListTile(
          leading: Icon(
            EvaIcons.shareOutline,
          ),
          title: Text("Share app"),
        ),
        ListTile(
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => const AboutAppPage(),
            ));
          },
          leading: const Icon(
            EvaIcons.infoOutline,
          ),
          title: const Text("About App"),
        ),
      ]),
    );
  }
}

class AboutAppPage extends StatelessWidget {
  const AboutAppPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("App info"),
      ),
      body: Column(
        children: [
          Image.asset(
            "assets/images/logo_dark.png",
            width: 157,
            height: 161,
          ),
          const Text("I PICK U ",
              style: TextStyle(
                fontSize: 50,
                fontWeight: FontWeight.w400,
              )),
          const Padding(
            padding: EdgeInsets.all(10.0),
            child: Text(
                "Welcome to I Pick U - Where Connections Blossom! Looking for meaningful connections in the world of dating? Look no further than I Pick U! Our app is designed to help you forge genuine relationships through video calls, real-time chat, and smart matching algorithms  \nHow It Works:  \nCreate Your Profile:  \nExplore Matches:  \nInitiate Conversations Build Connections \n\nJoin I Pick U today and let's start making meaningful connections together!",
                textAlign: TextAlign.justify,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                )),
          ),
        ],
      ),
    );
  }
}
