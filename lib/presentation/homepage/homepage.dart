import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ipicku_dating_app/domain/notifications/notifications_bloc.dart';
import 'package:ipicku_dating_app/presentation/profile/pages/account_details.dart';
import 'package:ipicku_dating_app/presentation/ui_utils/colors.dart';
import 'package:ipicku_dating_app/data/repositories/user_repositories.dart';
import 'package:ipicku_dating_app/domain/matching_bloc/matching_bloc.dart';
import 'package:ipicku_dating_app/domain/firebase_data/firebase_data_bloc.dart';
import 'package:ipicku_dating_app/presentation/homepage/notifications_page.dart';
import 'package:ipicku_dating_app/presentation/homepage/widgets/date_container.dart';
import 'package:ipicku_dating_app/presentation/widgets/empty_list.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

class HomePage extends StatefulWidget {
  final UserRepository userRepository;

  const HomePage({Key? key, required this.userRepository}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  bool isRandomUsersLoaded = false;
  bool showBanner = false; // Add this variable
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        BlocProvider.of<MatchingBloc>(context).add(GetRandomUsers());
        BlocProvider.of<NotificationsBloc>(context).add(GetNotifications());
        BlocProvider.of<FirebaseDataBloc>(context)
            .add(FirebaseDataLoadedEvent());
        WidgetsBinding.instance.addObserver(this);
        UserRepository().setStatus(true);
      },
    );
    super.initState();
    // Dispatch the event only if random users data is not already loaded
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state != AppLifecycleState.resumed) {
      UserRepository().setStatus(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text("I Pick U"),
        centerTitle: true,
        leading: IconButton(
          onPressed: () async {
            final userData = await widget.userRepository.getUserMap();
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => ProfileScreen(
                userData: userData ?? {},
                userRepository: widget.userRepository,
              ),
            ));
          },
          icon: Icon(LineAwesomeIcons.user),
        ),
        actions: [
          IconButton(
              onPressed: () {
                BlocProvider.of<MatchingBloc>(context).add(GetRandomUsers());
                BlocProvider.of<FirebaseDataBloc>(context)
                    .add(FirebaseDataLoadedEvent());
              },
              icon: const Icon(Icons.refresh)),
          BlocBuilder<NotificationsBloc, NotificationsState>(
            builder: (context, state) {
              if (state is GetNotificationsLoaded) {
                final data = state.data;
                return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                  stream: data,
                  builder: (context, snapshot) {
                    final userdata = snapshot.data?.docs ?? [];
                    return IconButton(
                      onPressed: () {
                        Navigator.of(context)
                            .push(
                          MaterialPageRoute(
                            builder: (context) =>
                                NotificationsPage(data: userdata),
                          ),
                        )
                            .then((_) {
                          // Set showBanner to true when coming back from the notification page
                          setState(() {
                            showBanner = true;
                          });
                        });
                      },
                      icon: Stack(
                        children: [
                          const Icon(Icons.notifications_none_rounded),
                          if (showBanner &&
                              userdata
                                  .isNotEmpty) // Show banner based on showBanner variable
                            Positioned(
                              right: 0,
                              child: Container(
                                padding: const EdgeInsets.all(1),
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                constraints: const BoxConstraints(
                                  minWidth: 12,
                                  minHeight: 12,
                                ),
                                child: Text(
                                  userdata.length.toString(),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 8,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                        ],
                      ),
                    );
                  },
                );
              }
              if (state is GetNotificationsError) {
                return IconButton(
                  onPressed: () {},
                  icon: Stack(
                    children: [
                      const Icon(Icons.notifications_none_rounded),
                      Positioned(
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.all(1),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          constraints: const BoxConstraints(
                            minWidth: 12,
                            minHeight: 12,
                          ),
                          child: const Text(
                            '0',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 8,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }
              return const SizedBox();
            },
          ),
        ],
      ),
      // drawer: ProfileDrawer(userRepository: widget.userRepository),
      body: BlocBuilder<MatchingBloc, MatchingState>(
        bloc: BlocProvider.of<MatchingBloc>(context),
        builder: (context, state) {
          if (state is RandomProfileLoading) {
            return const Center(
              child: CircularProgressIndicator(
                strokeWidth: 5.0,
                valueColor: AlwaysStoppedAnimation(AppTheme.red),
              ),
            );
          }
          if (state is RandomProfileLoaded) {
            if (state.userProfile.isNotEmpty) {
              return DateProfileContainer(
                size: size,
                userProfile: state.userProfile,
                userRepository: widget.userRepository,
              );
            }
            return const EmptyListPage(
              text: "Please refresh the page !!!",
            );
          }
          if (state is RandomProfileError) {
            return const EmptyListPage(text: "Please Refresh the Page");
          }
          return Center(
            child: GestureDetector(
              onTap: () {
                BlocProvider.of<MatchingBloc>(context).add(GetRandomUsers());
              },
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: SizedBox(
                  height: size.height,
                  width: size.width - 50,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
