import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ipicku_dating_app/data/repositories/user_repositories.dart';

enum NotificationType {
  messages,
  picks,
}

class InAppNotificatioons {
  final firebase = FirebaseFirestore.instance;

  Future<void> storeNotifications(
      String userId, String title, String body, NotificationType type) async {
    final ref = firebase.collection("users").doc(userId).collection("notify");

    await ref.add({
      'title': title,
      'body': body,
      'time': DateTime.now(),
      'type': type.name
    });
  }

  Future<Stream<QuerySnapshot<Map<String, dynamic>>>> getNotifications() async {
    final id = await UserRepository().getUser();
     return firebase.collection("users").doc(id).collection("notify").snapshots(includeMetadataChanges: true);

  }
}
