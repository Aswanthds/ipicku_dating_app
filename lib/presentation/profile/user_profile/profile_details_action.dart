import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:ipicku_dating_app/constants.dart';

class ProfileDetailsAction extends StatelessWidget {
  const ProfileDetailsAction({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton.icon(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.green,
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)))),
          // child: const Text('Cancel', style: TextStyle(color: Colors.black)),
          label: const Text(
            'Message',
            style: TextStyle(
              color: AppTheme.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          icon: const Icon(
            EvaIcons.messageSquare,
            color: AppTheme.black,
          ),
        ),
      ),
    );
  }
}
