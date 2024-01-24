import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:ipicku_dating_app/constants.dart';

ValueNotifier<int> indexChangeNotifier = ValueNotifier(0);

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
          selectedItemColor: AppTheme.black,
          type: BottomNavigationBarType.fixed,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          items: const [
            BottomNavigationBarItem(
              icon: ImageIcon(
                AssetImage('assets/images/logo_light.png'),
                size: 25,
              ),
              activeIcon: ImageIcon(
                AssetImage('assets/images/logo_light.png'),
                size: 25,
              ),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.recommend_outlined,
                size: 25,
                color: AppTheme.grey,
              ),
              activeIcon: Icon(
                Icons.recommend,
                size: 25,
              ),
              label: 'Recommended',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                EvaIcons.messageCircleOutline,
                size: 25,
              ),
              activeIcon: Icon(
                EvaIcons.messageCircle,
                size: 25,
              ),
              label: '',
            ),
          ],
        );
      },
    );
  }
}
