import 'package:flutter/material.dart';
import 'package:ipicku_dating_app/presentation/homepage/homepage.dart';
import 'package:ipicku_dating_app/presentation/profile/progfilepage.dart';
import 'package:ipicku_dating_app/presentation/recommended/recomended_page.dart';
import 'package:ipicku_dating_app/presentation/widgets/bottom_navigation.dart';

class MainPageNav extends StatelessWidget {
  const MainPageNav({super.key});

  @override
  Widget build(BuildContext context) {
    var pages = [
      const ProfilePage(),
      const HomePage(),
      const RecommendedPage(),
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
