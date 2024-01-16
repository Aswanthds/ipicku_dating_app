import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ipicku_dating_app/constants.dart';
import 'package:ipicku_dating_app/domain/firebase_bloc/firebase_data_bloc.dart';
import 'package:ipicku_dating_app/presentation/homepage/homepage.dart';
import 'package:ipicku_dating_app/presentation/profile/pages/account_details.dart';
import 'package:ipicku_dating_app/presentation/profile/pages/contact_us.dart';
import 'package:ipicku_dating_app/presentation/profile/pages/mypicks.dart';
import 'package:ipicku_dating_app/presentation/profile/pages/seettings.dart';
import 'package:ipicku_dating_app/presentation/profile/pages/who_picks_me.dart';
import 'package:ipicku_dating_app/presentation/profile/widgets/profile_list.dart';

class ProfileDrawer extends StatelessWidget {
  const ProfileDrawer({
    super.key,
    required this.size,
    required this.email,
    required this.id,
    required this.widget,
  });

  final Size size;
  final String? email;
  final String? id;
  final HomePage widget;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: size.width / 1.5,
      // child: ProfilePage(repository: userRepository),236

      child: BlocBuilder<FirebaseDataBloc, FirebaseDataState>(
          builder: (context, state) {
        if (state is FirebaseDataLoading) {
          // Loading state
          return const Center(child: CircularProgressIndicator());
        } else if (state is FirebaseDataLoaded) {
          return ListView(
            // Important: Remove any padding from the ListView.
            padding: EdgeInsets.zero,
            children: [
              UserAccountsDrawerHeader(
                accountName: Text(state.users.name ?? ''),
                accountEmail: Text(state.users.email ?? ''),
                currentAccountPicture: const CircleAvatar(
                  backgroundColor: Colors.black,
                  radius: 15,
                ),
              ),
              ProfileListTile(
                leading: EvaIcons.personOutline,
                text: "Account Details",
                onTap: () {
                  Navigator.pop(context);
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const AccountDetails(),
                  ));
                },
              ),
              ProfileListTile(
                leading: EvaIcons.settings,
                text: "Settings",
                onTap: () {
                  Navigator.pop(context);
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const SettingsPage(),
                  ));
                },
              ),
              ProfileListTile(
                leading: EvaIcons.heartOutline,
                text: "My Picks",
                onTap: () {
                  Navigator.pop(context);
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const MyPicksPage(),
                  ));
                },
              ),
              ProfileListTile(
                leading: EvaIcons.bookOutline,
                text: "Who Picks Me ?",
                onTap: () {
                  Navigator.pop(context);
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const WhoPicksMePage(),
                  ));
                },
              ),
              ProfileListTile(
                leading: EvaIcons.messageCircle,
                text: "Contact Us",
                onTap: () {
                  Navigator.pop(context);
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const ContactUsPage(),
                  ));
                },
              ),
              OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                    minimumSize: Size(size.width - 30, 35)),
                onPressed: () {
                  Navigator.of(context).pop();
                  showLogoutDialog(context, widget.userRepository);
                },
                icon: const Icon(
                  EvaIcons.logOut,
                  color: Colors.black,
                ),
                label: const Text(
                  "Log Out",
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ],
          );
        }
        return const SizedBox();
      }),
    );
  }
}
