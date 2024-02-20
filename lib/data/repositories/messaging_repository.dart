import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:ipicku_dating_app/data/model/message.dart';
import 'package:ipicku_dating_app/data/repositories/matches_repo.dart';
import 'package:ipicku_dating_app/data/repositories/user_repositories.dart';
import 'package:uuid/uuid.dart';

class MessagingRepository {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;
  String uuid = const Uuid().v4();

  static Future<void> sendMessage({
    required String recieverId,
    String? content,
    File? image,
  }) async {
    final Timestamp timestamp = Timestamp.now();
    final userId = FirebaseAuth.instance.currentUser!.uid;
    MessageType messageType =
        content != null ? MessageType.text : MessageType.image;

    

    List<String> ids = [userId, recieverId];
    ids.sort();
    String chatRoom = ids.join('_');

    if (messageType == MessageType.text) {
      final message = {
        'recieverId': recieverId,
        'senderId': userId,
        'sentTime': timestamp,
        'text': content,
        'type': messageType.name,
      };
      await _firestore
          .collection('chat_rooms')
          .doc(chatRoom)
          .collection('messages')
          .add(message);
    } else if (messageType == MessageType.image && image != null) {
     
      final storageRef = _firebaseStorage
          .ref()
          .child('chat_rooms_photos')
          .child(chatRoom)
          .child('${timestamp.seconds}_pic.png');
      await storageRef.putFile(image);

      final url = await storageRef.getDownloadURL();
      debugPrint(url);
       final message = {
        'recieverId': recieverId,
        'senderId': userId,
        'sentTime': timestamp,
        'photoUrl': url,
        'type': messageType.name,
      };
      // Add the message to Firestore
      await _firestore
          .collection('chat_rooms')
          .doc(chatRoom)
          .collection('messages')
          .add(message);
    }
  }

  static Future<QueryDocumentSnapshot<Map<String, dynamic>>?> getLastMessage(
      String recieverId) async {
    try {
      List<String> ids = [FirebaseAuth.instance.currentUser!.uid, recieverId];
      ids.sort();
      String chatRoom = ids.join('_');
      final data = await _firestore
          .collection('chat_rooms')
          .doc(chatRoom)
          .collection('messages')
          .orderBy('sentTime', descending: true)
          .snapshots(includeMetadataChanges: true)
          .first;

      return data.docs.first;
    } catch (e) {
      return null;
    }
  }

  static Stream<QuerySnapshot> getMessages(String? userId, String? recieverId) {
    List<String> ids = [userId ?? '', recieverId ?? ''];
    ids.sort();
    String chatRoom = ids.join('_');

    return _firestore
        .collection('chat_rooms')
        .doc(chatRoom)
        .collection('messages')
        .orderBy('sentTime', descending: false)
        .snapshots(includeMetadataChanges: true);
  }

  static Future<List<Map<String, dynamic>>> getUserChatList() async {
    try {
      final userId = await UserRepository().getUser();

      List<Map<String, dynamic>> userList = [];

      final mutualData = await MatchesRepository().getMutualList();

      for (var userData in mutualData) {
        final id = userData['uid'];

        final userDocRef = usersCollection.doc(id);
        final userDocSnapshot = await userDocRef.get();
        final userDocData = userDocSnapshot.data();

        final blockedSnapshot =
            await userDocRef.collection('blocked_by').doc(userId).get();

        if (blockedSnapshot.exists) {
          final blockedData = blockedSnapshot.data();

          userDocData?.addAll({
            'blocked': blockedData?['blocked'] ?? false,
            'done_by': blockedData?['done_by'] ?? userId,
            'muted': blockedData?['muted'] ?? false,
          });
        } else {
          // If not blocked, you might want to set a default value or handle it as needed
          userDocData?.addAll({
            'blocked': false,
            'done_by': userId,
            'muted': false,
          });
        }

        userList.add(userDocData ?? {});
      }

      return userList;
    } catch (e) {
      // Handle the error, you might want to log it or return an empty list
      debugPrint('Error fetching user details: $e');
      return [];
    }
  }

  static Future<void> deleteUserChat(String? recieverId) async {
    try {
      final id = await UserRepository().getUser();
      List<String> ids = [id, recieverId ?? ''];
      ids.sort();
      String chatRoom = ids.join('_');
      debugPrint(chatRoom);
      final daref = await _firestore
          .collection('chat_rooms')
          .doc(chatRoom)
          .collection('messages')
          .get();
      for (var d in daref.docs) {
        await d.reference.delete();
      }
    } catch (e) {
      // Handle the error, you might want to log it or return an empty list
      debugPrint('Error fetching user details: $e');
    }
  }

  static Future<void> deleteMessage(String chatRoom, String messageId) async {
    try {
      await FirebaseFirestore.instance
          .collection('chat_rooms')
          .doc(chatRoom)
          .collection('messages')
          .doc(messageId)
          .delete();

      debugPrint('Message deleted successfully');
    } catch (error) {
      debugPrint('Error deleting message: $error');
    }
  }

  Future<void> addToBlockedList(String blockedUser, bool value) async {
    final current = FirebaseAuth.instance.currentUser!.uid;
    await FirebaseFirestore.instance
        .collection('users')
        .doc(blockedUser)
        .collection('blocked_by')
        .doc(current)
        .set({
      'done_by': current,
      'blocked': value,
    }, SetOptions(merge: true));
  }

  Future<void> addToMutedList(String blockedUser, bool messagesValue) async {
    final current = FirebaseAuth.instance.currentUser!.uid;
    await FirebaseFirestore.instance
        .collection('users')
        .doc(blockedUser)
        .collection('blocked_by')
        .doc(current)
        .set({
      'muted': messagesValue,
      'done_by': current,
    }, SetOptions(merge: true));
  }

  Future<bool> isMuted(String selectedUser) async {
    final String currentUser = FirebaseAuth.instance.currentUser!.uid;
    final blockedata = await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser)
        .collection('blocked_by')
        .doc(selectedUser)
        .get();

    if (blockedata.exists) {
      final userMessages = blockedata['muted'] as bool;
      return userMessages;
    } else {
      return false;
    }
  }

  Future<Map<String, dynamic>> isBlocked(String selectedUser) async {
    final String currentUser = FirebaseAuth.instance.currentUser!.uid;
    final blockedata = await FirebaseFirestore.instance
        .collection('users')
        .doc(selectedUser)
        .collection('blocked_by')
        .doc(currentUser)
        .get();

    if (blockedata.exists) {
      final data = blockedata.data();

      final isBlocked = data?['blocked'] as bool;
      final blockedBy = data?['done_by'] as String;
      debugPrint("$isBlocked -> $blockedBy");
      return {
        'blocked': isBlocked,
        'done_by': blockedBy,
      };
    } else {
      return {};
    }
  }
}

/*


static Future<List<Map<String, dynamic>>> getUserChatList() async {
    try {
      final userId = await UserRepository().getUser();

      List<Map<String, dynamic>> userList = [];

      final mutualData = await MatchesRepository().getMutualList();

      for (var userData in mutualData) {
        final id = userData['uid'];
        // Map<String, dynamic> newData = {...userData};
        final blockedSnapshot =
            await usersCollection.doc(id).collection('blocked_by').get();

        print(' No . of blocked users ${blockedSnapshot.docs.length}');

        //   if (blockedSnapshot.docs.isNotEmpty) {
        //     userList.addAll(blockedDataForCurrentUser);
        //     usersCollection.doc(id).collection('blocked_by').doc(id).set({
        //       'blocked': false,
        //       'done_by': userId,
        //       'status': false,
        //       'muted': false,
        //     }, SetOptions(merge: true));
        //   } else {
        //     usersCollection.doc(id).collection('blocked_by').doc(id).set({
        //       'blocked': false,
        //       'done_by': userId,
        //       'status': false,
        //       'muted': false,
        //     },SetOptions(merge: true));
        //   }
        //   userList.add(userData);
        //   debugPrint(userData['blocked'].toString());
      }

      return await MatchesRepository().getMatchedList(userId);
    } catch (e) {
      // Handle the error, you might want to log it or return an empty list
      debugPrint('Error fetching user details: $e');
      return [];
    }
  }
the function should work in a way that it will get the user profiles which are common in both my picks and who picks me in current user. also it should fetch the whole data of the  userid as a doc in userCollection. when getting the whole data it should fetch the sub collection named as blocked_by .
the blocked by has all the users who have done muted or blocked the current user. if the blocked_by have the current user along with whole data it should add blocked_by to the list 
*/