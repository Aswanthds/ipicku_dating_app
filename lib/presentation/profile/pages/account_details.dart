import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ipicku_dating_app/domain/firebase_data/firebase_data_bloc.dart';
import 'package:ipicku_dating_app/domain/theme/theme_bloc.dart';
import 'package:ipicku_dating_app/domain/theme/theme_event.dart';
import 'package:ipicku_dating_app/presentation/profile/pages/mutual_picks.dart';
import 'package:ipicku_dating_app/presentation/profile/pages/mypicks.dart';
import 'package:ipicku_dating_app/presentation/profile/pages/seettings.dart';
import 'package:ipicku_dating_app/presentation/profile/pages/update_profile.dart';
import 'package:ipicku_dating_app/presentation/profile/pages/who_picks_me.dart';
import 'package:ipicku_dating_app/presentation/profile/widgets/profile_menu_widget.dart';
import 'package:ipicku_dating_app/presentation/ui_utils/colors.dart';
import 'package:ipicku_dating_app/data/model/user.dart';
import 'package:ipicku_dating_app/data/repositories/user_repositories.dart';
import 'package:ipicku_dating_app/presentation/profile/widgets/preferences_section.dart';
import 'package:ipicku_dating_app/presentation/profile/widgets/profile_card.dart';
import 'package:ipicku_dating_app/presentation/profile/widgets/user_details_widget.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

class AccountDetails extends StatelessWidget {
  final Map<String, dynamic> userData;
  final UserRepository userRepository;
  const AccountDetails({
    Key? key,
    required this.userData,
    required this.userRepository,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text(
            'Account Details',
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
        body: BlocBuilder<FirebaseDataBloc, FirebaseDataState>(
            builder: (context, state) {
          if (state is FirebaseDataLoaded) {
            return SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppTheme.white,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    //const SizedBox(height: 10),
                    ProfileCardWidget(
                        path: state.data?['photoUrl'] ?? '',
                        age: state.data?['age']?.toString() ?? '',
                        id: state.data?['uid']
                            .substring(userData['uid'].length - 5),
                        name: userData['name'] ?? ''),

                    UserDetailsList(user: UserModel.fromJson(userData)),
                    const SizedBox(height: 20),
                    PreferencesSection(model: userData, repo: userRepository)
                  ],
                ),
              ),
            );
          } else if (state is FirebaseDataLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          return const SizedBox();
        }));
  }
}

class ProfileScreen extends StatefulWidget {
  final Map<String, dynamic> userData;
  final UserRepository userRepository;
  const ProfileScreen(
      {Key? key, required this.userData, required this.userRepository})
      : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    var isDark = MediaQuery.of(context).platformBrightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        surfaceTintColor: Theme.of(context).scaffoldBackgroundColor,
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(LineAwesomeIcons.angle_left_solid)),
        title: Text("User Profile",
            style: Theme.of(context).textTheme.headlineSmall),
        actions: [
          IconButton(
              onPressed: () {
                setState(() {
                  isDark = !isDark;
                });
                BlocProvider.of<ThemeBloc>(context).add(ThemeSwitchEvent());
              },
              icon: Icon(isDark ? LineAwesomeIcons.sun : LineAwesomeIcons.moon))
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              /// -- IMAGE
              Stack(
                children: [
                  SizedBox(
                    width: 120,
                    height: 120,
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: Image(
                            fit: BoxFit.fitWidth,
                            image: CachedNetworkImageProvider(
                                widget.userData['photoUrl']))),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: 35,
                      height: 35,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          color: Colors.amber),
                      child: const Icon(
                        LineAwesomeIcons.pencil_alt_solid,
                        color: Colors.black,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(widget.userData['name'],
                  style: Theme.of(context).textTheme.headlineMedium),
              Text('${widget.userData["age"]} years old',
                  style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 20),

              /// -- BUTTON
              SizedBox(
                width: 200,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => UpdateProfileScreen(
                        userData: widget.userData,
                        userRepository: widget.userRepository,
                      ),
                    ));
                  },
                  // => Get.to(() => const UpdateProfileScreen()),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      side: BorderSide.none,
                      shape: const StadiumBorder()),
                  child: const Text("EditProfile",
                      style: TextStyle(color: Colors.black)),
                ),
              ),
              const SizedBox(height: 30),
              const Divider(),
              const SizedBox(height: 10),

              /// -- MENU
              ProfileMenuWidget(
                  title: "Settings",
                  icon: LineAwesomeIcons.cog_solid,
                  textColor: Theme.of(context).textTheme.headlineLarge?.color,
                  onPress: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const SettingsPage(),
                    ));
                  }),
              // ProfileMenuWidget(
              //     title: "Billing Details",
              //     icon: LineAwesomeIcons.wallet_solid,
              //     onPress: () {}),
              ProfileMenuWidget(
                  title: "My Likes",
                  textColor: Theme.of(context).textTheme.headlineLarge?.color,
                  icon: LineAwesomeIcons.user_check_solid,
                  onPress: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const MyPicksPage(),
                    ));
                  }),
              ProfileMenuWidget(
                  title: "Who Picks Me",
                  icon: LineAwesomeIcons.heartbeat_solid,
                  textColor: Theme.of(context).textTheme.headlineLarge?.color,
                  onPress: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const WhoPicksMePag(),
                    ));
                  }),
              ProfileMenuWidget(
                  title: "Mutual Picks",
                  icon: LineAwesomeIcons.heart_solid,
                  textColor: Theme.of(context).textTheme.headlineLarge?.color,
                  onPress: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const MutualPicks(),
                    ));
                  }),
              const Divider(),
              const SizedBox(height: 10),
              ProfileMenuWidget(
                  title: "Information",
                  textColor: Theme.of(context).textTheme.headlineLarge?.color,
                  icon: LineAwesomeIcons.info_solid,
                  onPress: () {}),
              ProfileMenuWidget(
                  title: "Logout",
                  icon: LineAwesomeIcons.sign_out_alt_solid,
                  textColor: Colors.red,
                  endIcon: false,
                  onPress: () {
                    // Get.defaultDialog(
                    //   title: "LOGOUT",
                    //   titleStyle: const TextStyle(fontSize: 20),
                    //   content: const Padding(
                    //     padding: EdgeInsets.symmetric(vertical: 15.0),
                    //     child: Text("Are you sure, you want to Logout?"),
                    //   ),
                    //   confirm: Expanded(
                    //     child: ElevatedButton(
                    //       onPressed: () =>
                    //           AuthenticationRepository.instance.logout(),
                    //       style: ElevatedButton.styleFrom(
                    //           backgroundColor: Colors.redAccent,
                    //           side: BorderSide.none),
                    //       child: const Text("Yes"),
                    //     ),
                    //   ),
                    //   cancel: OutlinedButton(
                    //       onPressed: () => Get.back(), child: const Text("No")),
                    // );
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
