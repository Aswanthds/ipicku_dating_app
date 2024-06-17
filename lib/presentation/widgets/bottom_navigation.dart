import 'package:flutter/material.dart';
import 'package:ipicku_dating_app/presentation/ui_utils/colors.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

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
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                LineAwesomeIcons.smile,
                size: 25,
              ),
              activeIcon: Icon(
                LineAwesomeIcons.surprise,
                size: 25,
              ),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                LineAwesomeIcons.inbox_solid,
                size: 25,
              ),
              activeIcon: Icon(
                LineAwesomeIcons.inbox_solid,
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
