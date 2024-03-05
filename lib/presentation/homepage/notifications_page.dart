import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:ipicku_dating_app/presentation/ui_utils/colors.dart';
import 'package:ipicku_dating_app/presentation/widgets/empty_page.dart';
import 'package:timeago/timeago.dart';

class NotificationsPage extends StatelessWidget {
  final List<QueryDocumentSnapshot<Map<String, dynamic>>> data;
  const NotificationsPage({super.key, required this.data});
  static const route = '/notification_page';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Notification'),
        ),
        body: data.isEmpty ? const EmptyPageGif(text: 'No Notifications'): ListView.separated(
                itemBuilder: (context, index) => NotificationItem(
                      time: format((data[index]['time'] as Timestamp).toDate(),
                          allowFromNow: true,
                          clock: DateTime.now(),
                          locale: 'en'),
                      subtitle: '${data[index]['body']}',
                      title: data[index]['title'],
                      type: data[index]['type'],
                    ),
                separatorBuilder: (context, index) => const Divider(),
                itemCount: data.length));
  }
}

class NotificationItem extends StatelessWidget {
  final String subtitle, time;
  final String title, type;

  const NotificationItem({
    super.key,
    required this.subtitle,
    required this.time,
    required this.title,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: leadingWidget(type),
      subtitle: Text(
        subtitle,
        style: Theme.of(context).textTheme.titleMedium,
      ),
      title: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium,
      ),
      trailing: Text(
        time,
        style: Theme.of(context).textTheme.titleSmall,
      ),
    );
  }

  Widget leadingWidget(String type) {
    switch (type) {
      case 'picks':
        return const CircleAvatar(
          radius: 20,
          backgroundColor: Colors.yellow,
          child: Icon(
            EvaIcons.heart,
            color: AppTheme.red,
          ),
        );

      case 'messages':
        return const CircleAvatar(
          radius: 20,
          backgroundColor: AppTheme.yellow,
          child: Icon(
            EvaIcons.messageCircle,
            color: AppTheme.blue,
          ),
        );
      default:
        return const CircleAvatar(
          radius: 20,
          backgroundColor: Colors.yellow,
          child: Icon(
            EvaIcons.alertCircle,
            color: AppTheme.red,
          ),
        );
    }
  }
}
