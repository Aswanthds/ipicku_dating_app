import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';

class ProfileDetailsListTile extends StatelessWidget {
  final BuildContext context;
  final String heading;
  final String value;
  final bool isEditable;
  const ProfileDetailsListTile({
    super.key,
    required this.context,
    required this.heading,
    required this.value,
    required this.isEditable,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          heading,
          textAlign: TextAlign.start,
          style: const TextStyle(
            color: Colors.black,
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Text(
                value,
                textAlign: TextAlign.justify,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: isEditable ? Colors.black : Colors.blue,
                ),
              ),
            ),
            Visibility(
              visible: isEditable,
              child: IconButton(
                onPressed: () {
                  // Handle edit button press
                },
                icon: const Icon(
                  EvaIcons.edit2,
                  color: Colors.black,
                  size: 18,
                ),
              ),
            ),
          ],
        )
      ],
    );
  }
}
