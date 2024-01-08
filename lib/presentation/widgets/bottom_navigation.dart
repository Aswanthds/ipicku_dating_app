import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';

ValueNotifier<int> indexChangeNotifier = ValueNotifier(1);

class BottomNavigation extends StatelessWidget {
  const BottomNavigation({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: indexChangeNotifier,
      builder: (context, newIndex, _) {
        return BottomNavigationBar(
          onTap: (value) {
            indexChangeNotifier.value = value;
          },
          currentIndex: newIndex,
          selectedItemColor: Colors.black,
          type: BottomNavigationBarType.fixed,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(
                EvaIcons.person,
                size: 25,
              ),
              activeIcon: Icon(
                EvaIcons.person,
                size: 25,
              ),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: ImageIcon(
                AssetImage('assets/images/logo_light.png'),
                size: 25,
              ),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.recommend_outlined,
                size: 25,
                color: Colors.grey,
              ),
              activeIcon: Icon(
                Icons.recommend,
                size: 25,
              ),
              label: 'Recommended',
            ),
          ],
        );
      },
    );
  }
}
