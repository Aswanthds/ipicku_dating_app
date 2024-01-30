import 'package:flutter/material.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notification'),
      ),
      body: const Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            height: 20,
          ),
          NotificationItem(
            time: 'now',
            subtitle: 'You have a new message.',
          ),
          NotificationItem(
            time: '3 min ago',
            subtitle: 'You have a new match! Check it out.',
          ),
          NotificationItem(
            time: '4h ago',
            subtitle: 'Someone likes your profile.',
          ),
        ],
      ),
    );
  }
}

class NotificationItem extends StatelessWidget {
  final String subtitle, time;

  const NotificationItem({
    super.key,
    required this.subtitle,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const CircleAvatar(
        radius: 20,
        backgroundColor: Colors.orange,
      ),
      title: Text(
        subtitle,
        style: Theme.of(context).textTheme.titleMedium,
      ),
      trailing: Text(
        time,
        style: Theme.of(context).textTheme.titleSmall,
      ),
    );
  }
}
