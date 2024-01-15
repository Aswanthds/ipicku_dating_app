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
          onPressed: () {
            // Handle message button click
          },
          child: const Text('Message'),
        ),
        ElevatedButton(
          onPressed: () {
            // Handle share profile button click
          },
          child: const Text('Share Profile'),
        ),
      ],
    );
  }
}
