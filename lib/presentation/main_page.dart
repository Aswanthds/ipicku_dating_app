import 'package:flutter/material.dart';
import 'package:ipicku_dating_app/data/repositories/user_repositories.dart';
import 'package:ipicku_dating_app/presentation/chatpage/chatpage.dart';
import 'package:ipicku_dating_app/presentation/homepage/homepage.dart';
import 'package:ipicku_dating_app/presentation/recommended/recomended_page.dart';
import 'package:ipicku_dating_app/presentation/widgets/bottom_navigation.dart';

class MainPageNav extends StatefulWidget {
  final UserRepository repository;
  const MainPageNav({super.key, required this.repository});

  @override
  State<MainPageNav> createState() => _MainPageNavState();
}

class _MainPageNavState extends State<MainPageNav> {
  String userId = '';
  getUserId() async {
    await widget.repository.storeDeviceToken();
    return userId = await widget.repository.getUser();
    
  }

  @override
  void initState() {
    getUserId();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var pages = [
      HomePage(userRepository: widget.repository),
      RecommendedPage(repository: userId),
      ChatPage(
        userid: userId,
      ),
    ];
    return Scaffold(
      body: ValueListenableBuilder(
        valueListenable: indexChangeNotifier,
        builder: (context, index, _) {
          return pages[index];
        },
      ),
      bottomNavigationBar: const BottomNavigation(),
    );
  }
}
