import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ipicku_dating_app/domain/theme/theme_bloc.dart';
import 'package:ipicku_dating_app/presentation/ui_utils/colors.dart';

class ContactUsPage extends StatelessWidget {
  const ContactUsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Contact Us"),
      ),
      body: ListView(children: [
        ListTile(
          leading: Icon(
            Icons.report_gmailerrorred_sharp,
            color: Theme.of(context).textTheme.bodyLarge?.color,
          ),
          title: Text("Report a problem",
              style: Theme.of(context).textTheme.bodyLarge),
        ),
        ListTile(
          onTap: () {
// Navigator.of(context).push(MaterialPageRoute(builder: (context) => ,))
          },
          leading: Icon(
            Icons.feedback_outlined,
            color: Theme.of(context).textTheme.bodyLarge?.color,
          ),
          title: Text(
            "Send Feedback",
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ),
        ListTile(
          leading: Icon(
            EvaIcons.shareOutline,
            color: Theme.of(context).textTheme.bodyLarge?.color,
          ),
          title: Text(
            "Share app",
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ),
        ListTile(
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => const AboutAppPage(),
            ));
          },
          leading: Icon(
            EvaIcons.infoOutline,
            color: Theme.of(context).textTheme.bodyLarge?.color,
          ),
          title: Text(
            "About App",
            style: Theme.of(context).textTheme.bodyLarge,
          ),
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
          BlocBuilder<ThemeBloc, ThemeData>(builder: (context, theme) {
            if (theme == AppTheme.darkTheme) {
              return Image.asset(
                "assets/images/logo_light.png",
                width: 157,
                height: 161,
              );
            }
            return Image.asset(
              "assets/images/logo_dark.png",
              width: 157,
              height: 161,
            );
          }),
          Text("I PICK U ",
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontSize: 50,
                    fontWeight: FontWeight.w400,
                  )),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text(
                "Welcome to I Pick U - Where Connections Blossom! Looking for meaningful connections in the world of dating? Look no further than I Pick U! Our app is designed to help you forge genuine relationships through video calls, real-time chat, and smart matching algorithms  ",
                textAlign: TextAlign.justify,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontSize: 18,
                      fontWeight: FontWeight.w400,
                    )),
          ),
        ],
      ),
    );
  }
}
//\nHow It Works:  \nCreate Your Profile:  \nExplore Matches:  \nInitiate Conversations Build Connections \n\nJoin I Pick U today and let's start making meaningful connections together!