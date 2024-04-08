import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class VideoRepository {
  
  static void storeVideoDetails(String selectedUser, String videoToken) async {
    final current = FirebaseAuth.instance.currentUser?.uid;

    final users = FirebaseFirestore.instance.collection('users').doc(current);
    final select =
        FirebaseFirestore.instance.collection('users').doc(selectedUser);

    final data = await users.get();

    final userData = data.data();
    final selData = await select.get();
    final selectedUSerData = selData.data();

    final sendData = {
      'fromName': userData?['name'],
      'fromPhoto': userData?['photoUrl'],
      'from': current,
      'to': selectedUser,
      'toName': selectedUSerData?['name'],
      'toPhoto': selectedUSerData?['photoUrl'],
      'token': videoToken,
      'time': Timestamp.now(),
    };
    await FirebaseFirestore.instance
        .collection('videochat')
        .doc(current)
        .collection('videochat')
        .add(sendData);
    await FirebaseFirestore.instance
        .collection('videochat')
        .doc(selectedUser)
        .collection('videochat')
        .add(sendData);
  }

  static Future<List<Map<String, dynamic>>> getVideoCallDetails() async {
    final current = FirebaseAuth.instance.currentUser?.uid;

    final ref = await FirebaseFirestore.instance
        .collection('videochat')
        .doc(current)
        .collection('videochat')
        .orderBy('time', descending: true)
        .get();

    return ref.docs.map((e) => e.data()).toList();
  }
}
