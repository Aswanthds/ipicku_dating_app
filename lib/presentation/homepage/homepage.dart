import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ipicku_dating_app/constants.dart';
import 'package:ipicku_dating_app/data/repositories/user_repositories.dart';
import 'package:ipicku_dating_app/domain/bloc/matching_bloc.dart';
import 'package:ipicku_dating_app/domain/firebase_data/firebase_data_bloc.dart';
import 'package:ipicku_dating_app/presentation/homepage/notifications_page.dart';
import 'package:ipicku_dating_app/presentation/homepage/widgets/date_container.dart';
import 'package:ipicku_dating_app/presentation/profile/profile_drawer.dart';

class HomePage extends StatefulWidget {
  final UserRepository userRepository;
  const HomePage({super.key, required this.userRepository});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    BlocProvider.of<FirebaseDataBloc>(context).add(FirebaseDataLoadedEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    BlocProvider.of<MatchingBloc>(context)
        .add(const GetRegionUsers(radius: 1.0));
    BlocProvider.of<MatchingBloc>(context).add(GetRandomUsers());
    return Scaffold(
        appBar: AppBar(
          title: const Text("I Pick U"),
          centerTitle: true,
          actions: [
            IconButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const NotificationsPage(),
                ));
              },
              icon: const Icon(EvaIcons.bellOutline),
            ),
          ],
        ),
        drawer: ProfileDrawer(userRepository: widget.userRepository),
        body:
            BlocBuilder<MatchingBloc, MatchingState>(builder: (context, state) {
          if (state is RandomProfileLoading) {
            return const Center(
              child: CircularProgressIndicator(
                strokeWidth: 5.0,
                valueColor: AlwaysStoppedAnimation(AppTheme.red),
              ),
            );
          }
          if (state is RandomProfileLoaded) {
            // Data is loaded, show DateProfileContainer
            return DateProfileContainer(
              size: size,
              state: state,
              userRepository: widget.userRepository,
            );
          }
          if (state is RandomProfileError) {
            return const Text("Error Occured ");
          }
          return const SizedBox();
        }));
  }
}
