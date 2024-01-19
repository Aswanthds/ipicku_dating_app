import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ipicku_dating_app/data/repositories/user_repositories.dart';
import 'package:ipicku_dating_app/domain/bloc/firebase_data_bloc.dart';
import 'package:ipicku_dating_app/presentation/homepage/widgets/actions_button.dart';
import 'package:ipicku_dating_app/presentation/homepage/widgets/date_container.dart';
import 'package:ipicku_dating_app/presentation/homepage/widgets/date_details_section.dart';
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
    return Scaffold(
      appBar: AppBar(
        title: const Text("I Pick U"),
        centerTitle: true,
      ),
      drawer: ProfileDrawer(userRepository: widget.userRepository),
      body: Stack(
        children: [
          DateProfileContainer(size: size),
          const Align(
            alignment: Alignment.bottomCenter,
            child: ActionsButton(),
          ),
          const Positioned(
            bottom: 80,
            left: 40,
            child: DateDetailsSection(),
          )
        ],
      ),
    );
  }
}
