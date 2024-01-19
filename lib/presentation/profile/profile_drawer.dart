import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ipicku_dating_app/constants.dart';
import 'package:ipicku_dating_app/data/model/user.dart';
import 'package:ipicku_dating_app/data/repositories/user_repositories.dart';
import 'package:ipicku_dating_app/domain/bloc/firebase_data_bloc.dart';

import 'package:ipicku_dating_app/presentation/profile/pages/account_details.dart';
import 'package:ipicku_dating_app/presentation/profile/pages/contact_us.dart';
import 'package:ipicku_dating_app/presentation/profile/pages/mypicks.dart';
import 'package:ipicku_dating_app/presentation/profile/pages/seettings.dart';
import 'package:ipicku_dating_app/presentation/profile/pages/who_picks_me.dart';
import 'package:ipicku_dating_app/presentation/profile/user_profile/image_preview.dart';
import 'package:ipicku_dating_app/presentation/profile/widgets/profile_list.dart';

class ProfileDrawer extends StatelessWidget {
  const ProfileDrawer({
    super.key,
    required this.userRepository,
  });
  final UserRepository userRepository;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    bool dataLoaded = false;
    return Drawer(
        width: size.width / 1.5,
        child: BlocBuilder<FirebaseDataBloc, FirebaseDataState>(
          builder: (context, state) {
            if (state is FirebaseDataFailure) {
              return Center(
                child: Text(state.messge),
              );
            }
            if (!dataLoaded && state is FirebaseDataLoading) {
              return const Center(
                child: CircularProgressIndicator(
                  strokeWidth: 2.0,
                  color: kPrimary,
                ),
              );
            }
            if (!dataLoaded && state is FirebaseDataLoaded) {
              dataLoaded = true;
              final user = state.data;
              return DrawerListView(
                user: user,
                size: size,
                userRepository: userRepository,
              );
            }
            return const SizedBox();
          },
        ));
  }
}

class DrawerListView extends StatelessWidget {
  const DrawerListView({
    super.key,
    required this.user,
    required this.size,
    required this.userRepository,
  });

  final UserModel? user;
  final Size size;
  final UserRepository userRepository;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.zero,
      children: [
        UserAccountsDrawerHeader(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                blurRadius: 5,
                color: Colors.black.withOpacity(0.4),
                spreadRadius: 12,
              ),
            ],
            borderRadius: BorderRadius.circular(10),
            color: kPrimary,
          ),
          accountName: Text("${user?.name}"),
          accountEmail: Text("${user?.email}"),
          currentAccountPicture: InkWell(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) =>
                    ImagePreviewPage(imageUrl: user?.photoPath ?? ''),
              ));
            },
            child: CircleAvatar(
              backgroundImage: NetworkImage(user?.photoPath ?? ''),
              radius: 15,
            ),
          ),
        ),
        ProfileListTile(
          leading: EvaIcons.personOutline,
          text: "Account Details",
          onTap: () {
            Navigator.pop(context);
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) =>
                  AccountDetails(state: user!, userRepository: userRepository),
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
          style:
              OutlinedButton.styleFrom(minimumSize: Size(size.width - 30, 35)),
          onPressed: () {
            Navigator.of(context).pop();
            showLogoutDialog(context, userRepository);
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
}
