import 'package:flutter/material.dart';

class ProfileDetailsAction extends StatelessWidget {
  const ProfileDetailsAction({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton(
          onPressed: () {},
          child: const Text('Message'),
        ),
        ElevatedButton(
          onPressed: () {},
          child: const Text('Share Profile'),
        ),
      ],
    );
  }
}
