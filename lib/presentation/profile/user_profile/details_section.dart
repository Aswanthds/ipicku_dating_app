import 'package:flutter/material.dart';

class DetailsSection extends StatelessWidget {
  const DetailsSection({
    super.key,
    required this.name,
    required this.age,
    required this.bio,
  });

  final String name;
  final int age;
  final String bio;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            name,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Age: $age',
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 8),
          Text(
            'Bio: $bio',
            style: const TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}
