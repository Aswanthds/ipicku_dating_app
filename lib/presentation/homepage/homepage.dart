import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ipicku_dating_app/constants.dart';
import 'package:ipicku_dating_app/data/repositories/user_repositories.dart';
import 'package:ipicku_dating_app/domain/bloc/matches_data_bloc.dart';
import 'package:ipicku_dating_app/domain/matching_bloc/matching_bloc.dart';
import 'package:ipicku_dating_app/domain/firebase_data/firebase_data_bloc.dart';
import 'package:ipicku_dating_app/presentation/homepage/notifications_page.dart';
import 'package:ipicku_dating_app/presentation/homepage/widgets/date_container.dart';
import 'package:ipicku_dating_app/presentation/profile/profile_drawer.dart';

class HomePage extends StatefulWidget {
  final UserRepository userRepository;

  const HomePage({Key? key, required this.userRepository}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isRandomUsersLoaded = false;

  @override
  void initState() {
    super.initState();
    // Dispatch the event only if random users data is not already loaded

    BlocProvider.of<MatchingBloc>(context).add(GetRandomUsers());
    BlocProvider.of<FirebaseDataBloc>(context).add(FirebaseDataLoadedEvent());
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return BlocListener<MatchesDataBloc, MatchesDataState>(
      listener: (context, state) {
        if (state is DatePickedState) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              backgroundColor: AppTheme.green,
              duration: Durations.short2,
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
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const NotificationsPage(),
                  ),
                );
              },
              icon: const Icon(EvaIcons.bellOutline),
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
              return DateProfileContainer(
                size: size,
                userProfile: state.userProfile,
                userRepository: widget.userRepository,
              );
            }
            if (state is RandomProfileError) {
              return const Text("Error Occurred");
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
