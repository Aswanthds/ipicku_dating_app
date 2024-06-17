import 'package:flutter/material.dart';
import 'package:ipicku_dating_app/presentation/ui_utils/colors.dart';

class DateDetailsSection extends StatelessWidget {
  final String name, age, bio;
  const DateDetailsSection({
    super.key,
    required this.name,
    required this.age,
    required this.bio,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
       Text(
          "${name.toUpperCase()} ",
          style: const TextStyle(
            color: AppTheme.white,
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
            "$age yrs old",
            style: const TextStyle(
              color: AppTheme.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        Text(
          (bio == 'null') ? '' : bio,
          style: const TextStyle(
            color: AppTheme.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
