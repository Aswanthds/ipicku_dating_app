import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ipicku_dating_app/domain/notifications/notifications_bloc.dart';
import 'package:ipicku_dating_app/presentation/ui_utils/colors.dart';
import 'package:ipicku_dating_app/data/repositories/user_repositories.dart';
import 'package:ipicku_dating_app/domain/matches_data_bloc/matches_data_bloc.dart';
import 'package:ipicku_dating_app/domain/matching_bloc/matching_bloc.dart';
import 'package:ipicku_dating_app/domain/firebase_data/firebase_data_bloc.dart';
import 'package:ipicku_dating_app/presentation/homepage/notifications_page.dart';
import 'package:ipicku_dating_app/presentation/homepage/widgets/date_container.dart';
import 'package:ipicku_dating_app/presentation/profile/profile_drawer.dart';
import 'package:ipicku_dating_app/presentation/widgets/empty_list.dart';

class HomePage extends StatefulWidget {
  final UserRepository userRepository;

  const HomePage({Key? key, required this.userRepository}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  bool isRandomUsersLoaded = false;

  @override
  void initState() {
    super.initState();
    // Dispatch the event only if random users data is not already loaded

    BlocProvider.of<MatchingBloc>(context).add(GetRandomUsers());
    WidgetsBinding.instance.addObserver(this);
    UserRepository().setStatus(true);
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
    BlocProvider.of<NotificationsBloc>(context).add(GetNotifications());
    return BlocListener<MatchesDataBloc, MatchesDataState>(
      listener: (context, state) {
        if (state is DatePickedState) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              backgroundColor: AppTheme.green,
              duration: Durations.medium4,
              behavior: SnackBarBehavior.floating,
              content: Text("User added as a pick")));
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("I Pick U"),
          centerTitle: true,
          actions: [
            IconButton(
                onPressed: () {
                  BlocProvider.of<MatchingBloc>(context).add(GetRandomUsers());
                  BlocProvider.of<FirebaseDataBloc>(context)
                      .add(FirebaseDataLoadedEvent());
                },
                icon: const Icon(EvaIcons.refresh)),
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
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) =>
                                    NotificationsPage(data: userdata),
                              ),
                            );
                          },
                          icon: Stack(
                            children: [
                              const Icon(
                                EvaIcons.bellOutline,
                              ),
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
                              )
                            ],
                          ),
                        );
                      });
                }
                if (state is GetNotificationsError) {
                  return IconButton(
                    onPressed: () {},
                    icon: Stack(
                      children: [
                        const Icon(
                          EvaIcons.bellOutline,
                        ),
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
                        )
                      ],
                    ),
                  );
                }
                return const SizedBox();
              },
            ),
          ],
        ),
        drawer: ProfileDrawer(userRepository: widget.userRepository),
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
      ),
    );
  }
}
