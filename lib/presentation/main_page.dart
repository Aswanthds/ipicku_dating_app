import 'package:flutter/material.dart';
import 'package:ipicku_dating_app/data/repositories/user_repositories.dart';
import 'package:ipicku_dating_app/presentation/chatpage/chatpage.dart';
import 'package:ipicku_dating_app/presentation/homepage/homepage.dart';
import 'package:ipicku_dating_app/presentation/recommended/recomended_page.dart';
import 'package:ipicku_dating_app/presentation/widgets/bottom_navigation.dart';

class MainPageNav extends StatelessWidget {
  final UserRepository repository;
  const MainPageNav({super.key, required this.repository});

  @override
  Widget build(BuildContext context) {
    var pages = [
      HomePage(userRepository: repository),
      const RecommendedPage(),
      const ChatPage(),
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
