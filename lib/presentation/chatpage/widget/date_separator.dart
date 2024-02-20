import 'package:flutter/material.dart';

class DateSeparatorWidget extends StatelessWidget {
  final DateTime date;

  const DateSeparatorWidget({Key? key, required this.date}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: const BoxDecoration(),
      child: Center(
        child: Text(
          _formatDate(date),
          style: const TextStyle(
            color: Colors.grey,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    // Customize the date format based on your preference
    return '${date.day}/${date.month}/${date.year}';
  }
}
