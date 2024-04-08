import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ipicku_dating_app/presentation/ui_utils/colors.dart';
import 'package:ipicku_dating_app/data/model/user.dart';
import 'package:ipicku_dating_app/data/repositories/user_repositories.dart';
import 'package:ipicku_dating_app/domain/firebase_data/firebase_data_bloc.dart';
import 'package:ipicku_dating_app/presentation/profile/pages/account_details.dart';
import 'package:ipicku_dating_app/presentation/profile/pages/contact_us.dart';
import 'package:ipicku_dating_app/presentation/profile/pages/mutual_picks.dart';
import 'package:ipicku_dating_app/presentation/profile/pages/mypicks.dart';
import 'package:ipicku_dating_app/presentation/profile/pages/seettings.dart';
import 'package:ipicku_dating_app/presentation/profile/pages/who_picks_me.dart';
import 'package:ipicku_dating_app/presentation/profile/user_profile/image_preview.dart';
import 'package:ipicku_dating_app/presentation/profile/widgets/profile_list.dart';
import 'package:ipicku_dating_app/presentation/ui_utils/dialog_manager.dart';

class ProfileDrawer extends StatefulWidget {
  const ProfileDrawer({
    super.key,
    required this.userRepository,
  });
  final UserRepository userRepository;

  @override
  State<ProfileDrawer> createState() => _ProfileDrawerState();
}

class _ProfileDrawerState extends State<ProfileDrawer> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    bool dataLoaded = false;
    return Drawer(
        width: size.width / 1.5,
        child: BlocBuilder<FirebaseDataBloc, FirebaseDataState>(
          builder: (context, state) {
            if (state is FirebaseDataFailure) {
              return const Center(
                child: Text("Wait Getting data......"),
              );
            }
            if (!dataLoaded && state is FirebaseDataLoading) {
              return const Center(
                child: CircularProgressIndicator(
                  strokeWidth: 2.0,
                  color: AppTheme.kPrimary,
                ),
              );
            }
            if (!dataLoaded && state is FirebaseDataLoaded) {
              dataLoaded = true;
              final user = state.data;
              return DrawerListView(
                user: user,
                size: size,
                userRepository: widget.userRepository,
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
                color: AppTheme.black.withOpacity(0.4),
                spreadRadius: 12,
              ),
            ],
            borderRadius: BorderRadius.circular(10),
            color:  Theme.of(context).bottomNavigationBarTheme.unselectedItemColor,
          ),
          accountName: Text("${user?.name}",style: Theme.of(context).textTheme.titleLarge?.copyWith(color: AppTheme.white),),
          accountEmail: Text("${user?.age} yrs old"),
          currentAccountPicture: InkWell(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) =>
                    ImagePreviewPage(imageUrl: user?.photoPath ?? ''),
              ));
            },
            child: user?.photoPath != null ? CircleAvatar(
              backgroundImage: NetworkImage(user?.photoPath ?? ''),
              radius: 15,
            ): const CircleAvatar(
                    backgroundImage: AssetImage('assets/images/image_place.png'),
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
            Navigator.of(context).pop();
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => const SettingsPage(),
            ));
          },
        ),
        ProfileListTile(
          leading: EvaIcons.heartOutline,
          text: "My Picks",
          onTap: () {
            Navigator.of(context).pop();
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => const MyPicksPage(),
            ));
          },
        ),
        ProfileListTile(
          leading: EvaIcons.bookOutline,
          text: "Who Picks Me ?",
          onTap: () {
            Navigator.of(context).pop();
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => WhoPicksMePag(
                user: user!,
              ),
            ));
          },
        ),
        ProfileListTile(
          leading: EvaIcons.npm,
          text: "Mutual Picks",
          onTap: () {
            Navigator.of(context).pop();
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => MutualPicks(
                user: user!,
              ),
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
            DialogManager.showLogoutDialog(context, userRepository);
          },
          icon: const Icon(
            EvaIcons.logOut,
            color: AppTheme.black,
          ),
          label: const Text(
            "Log Out",
            style: TextStyle(color: AppTheme.black),
          ),
        ),
      ],
    );
  }
}
