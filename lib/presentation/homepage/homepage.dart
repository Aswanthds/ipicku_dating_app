import 'package:flutter/material.dart';
import 'package:ipicku_dating_app/data/repositories/user_repositories.dart';
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
  String? id;
  String? email;

  getid() async {
    var ert = await widget.userRepository.getUser();
    var ema = await widget.userRepository.getUserEmail();
    setState(() {
      id = ert;
      email = ema;
    });
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      getid();
    });
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text("I Pick U"),
        centerTitle: true,
      ),
      drawer: ProfileDrawer(size: size, email: email, id: id, widget: widget),
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
