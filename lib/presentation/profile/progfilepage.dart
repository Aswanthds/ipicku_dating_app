import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Stack(
                  children: [
                    const CircleAvatar(
                      radius: 65,
                    ),
                    Positioned(
                        bottom: 0,
                        right: 0,
                        child: IconButton.filled(
                          onPressed: () {},
                          icon: const Icon(Icons.camera_alt),
                          iconSize: 20,
                        ))
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    const Text(
                      "My Photos",
                      style:
                          TextStyle(fontWeight: FontWeight.w200, fontSize: 20),
                    ),
                    IconButton(
                        onPressed: () {}, icon: const Icon(EvaIcons.edit))
                  ],
                ),
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children:
                      List<Widget>.generate(3, (index) => const ProfileImageWidget()),
                ),
              ),
              const ProfileListTile(
                leading: EvaIcons.personOutline,
                text: "Account Details",
              ),
              const ProfileListTile(
                leading: EvaIcons.settings,
                text: "Settings",
              ),
              const ProfileListTile(
                leading: EvaIcons.heartOutline,
                text: "My Picks",
              ),
              const ProfileListTile(
                leading: EvaIcons.bookOutline,
                text: "Who Picks Me ?",
              ),
              Center(
                child: OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                      minimumSize: Size(size.width - 30, 35)),
                  onPressed: () {},
                  icon: const Icon(
                    EvaIcons.logOut,
                    color: Colors.black,
                  ),
                  label: const Text(
                    "Log Out",
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class ProfileListTile extends StatelessWidget {
  final IconData leading;
  final String text;
  const ProfileListTile({
    super.key,
    required this.leading,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(leading),
      title: Text(text),
      trailing: const Icon(EvaIcons.arrowIosForwardOutline),
    );
  }
}

class ProfileImageWidget extends StatelessWidget {
  const ProfileImageWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 150,
        width: 105,
        margin: const EdgeInsets.only(left: 10),
        decoration: BoxDecoration(
            border: Border.all(
              style: BorderStyle.solid,
            ),
            borderRadius: BorderRadius.circular(12)),
        child: Center(
          child: IconButton(
              icon: const Icon(EvaIcons.imageOutline), onPressed: () {}),
        ));
  }
}
