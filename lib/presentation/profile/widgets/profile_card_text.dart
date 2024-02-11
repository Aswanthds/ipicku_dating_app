import 'package:flutter/material.dart';
import 'package:ipicku_dating_app/presentation/ui_utils/colors.dart';

class ProfileDetails extends StatelessWidget {
  final String name, age, uid;
  const ProfileDetails(
      {Key? key, required this.name, required this.age, required this.uid})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            text: "Name : ",
            style: const TextStyle(
              color: AppTheme.black,
            ),
            children: [
              TextSpan(
                text: name.toUpperCase(),
                style: const TextStyle(
                    fontWeight: FontWeight.bold, color: AppTheme.black),
              ),
            ],
          ),
        ),
        const SizedBox(height: 15),
        RichText(
          text: TextSpan(
            text: "Age : ",
            style: const TextStyle(
              color: AppTheme.black,
            ),
            children: [
              TextSpan(
                text: age,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppTheme.black,
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(
            top: 15.0,
          ),
          child: Text(
            uid.toUpperCase(),
            style: const TextStyle(
                fontWeight: FontWeight.bold, color: AppTheme.black),
          ),
        ),
      ],
    );
  }
}
