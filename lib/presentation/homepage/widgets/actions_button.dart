import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';

class ActionsButton extends StatelessWidget {
  const ActionsButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        IconButton(
          onPressed: () {},
          icon: const Icon(EvaIcons.slash),
          color: Colors.red,
          iconSize: 30,
        ),
        IconButton(
          onPressed: () {},
          icon: const ImageIcon(
            AssetImage('assets/images/logo_light.png'),
          ),
          iconSize: 50,
        ),
      ],
    );
  }
}
