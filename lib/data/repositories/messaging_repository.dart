import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
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
    XFile? image,
  }) async {
    final Timestamp timestamp = Timestamp.now();
    final userId = FirebaseAuth.instance.currentUser!.uid;
    MessageType messageType =
        content != null ? MessageType.text : MessageType.image;

    final message = Message(
      recieverId: recieverId,
      senderId: userId,
      sentTime: timestamp,
      text: content,
      type: messageType,
    );

    List<String> ids = [userId, recieverId];
    ids.sort();
    String chatRoom = ids.join('_');

    if (messageType == MessageType.text) {
      await _firestore
          .collection('chat_rooms')
          .doc(chatRoom)
          .collection('messages')
          .add(message.toJson());
    } else if (messageType == MessageType.image && image != null) {
      final ref =
          _firebaseStorage.ref().child("chat_room_photos").child(chatRoom);
      ref.putFile(File(image.path));

      // // Wait for the upload to complete
      // final TaskSnapshot uploadTaskSnapshot =
      //     await uploadTask.whenComplete(() {});

      // Get the download URL
      final downloadURL = await ref.getDownloadURL();
      debugPrint(downloadURL);
      // Set the 'photoUrl' field in the message
      message.photoUrl = downloadURL;

      // Add the message to Firestore
      await _firestore
          .collection('chat_rooms')
          .doc(chatRoom)
          .collection('messages')
          .add(message.toJson());
    }
  }

  static Future<QueryDocumentSnapshot<Map<String, dynamic>>> getLastMessage(
      String recieverId) async {
    List<String> ids = [FirebaseAuth.instance.currentUser!.uid, recieverId];
    ids.sort();
    String chatRoom = ids.join('_');
    final data = await _firestore
        .collection('chat_rooms')
        .doc(chatRoom)
        .collection('messages')
        .orderBy('sentTime', descending: true)
        .snapshots()
        .first;

    return data.docs.last;
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
      // final userId = await UserRepository().getUser();

      // final userSnapshot = await usersCollection
      //     .doc(userId)
      //     .collection('myPicks')
      //     .orderBy('timestamp', descending: true)
      //     .get();
      // final userSnapshot2 = await usersCollection
      //     .doc(userId)
      //     .collection('whoPicksMe')
      //     .orderBy('timestamp', descending: true)
      //     .get();

      // List<Map<String, dynamic>> userList = [];

      // // Extract document IDs from both collections
      // Set<String> documentIds1 =
      //     Set<String>.from(userSnapshot.docs.map((doc) => doc.id));
      // Set<String> documentIds2 =
      //     Set<String>.from(userSnapshot2.docs.map((doc) => doc.id));

      // // Find the common document IDs
      // Set<String> commonDocumentIds = documentIds1.intersection(documentIds2);
      // debugPrint(commonDocumentIds.join(' - '));

      // // Fetch user data and blocked_by data for the common document IDs
      // for (String documentId in commonDocumentIds) {
      //   DocumentSnapshot<Map<String, dynamic>> userSnapshot =
      //       await usersCollection.doc(documentId).get();
      //   final userData = userSnapshot.data();
      //   if (userData != null) {
      //     Map<String, dynamic> combinedData = {...userData};

      //     // Fetch blocked_by data for the current user from the other user's perspective
      //     final blockedSnapshot = await usersCollection
      //         .doc(documentId)
      //         .collection('blocked_by')
      //         .get();
      //     final blockedDataForCurrentUser = blockedSnapshot.docs
      //         .where((blockedDoc) =>
      //             blockedDoc.id == userId)
      //         .map((blockedDoc) => blockedDoc.data());
      //     // Check if blockedSnapshot exists
      //     if (blockedSnapshot.docs.isNotEmpty) {
      //       combinedData.addAll(blockedDataForCurrentUser.first);
      //     } else {
      //       // If blockedSnapshot does not exist, add the dummy data
      //       combinedData.addAll({
      //         'blocked': false,
      //         'done_by': userId,
      //       });
      //     }

      //     userList.add(combinedData);
      //     debugPrint(combinedData['blocked'].toString());
      //   }
      // }

      return await MatchesRepository().getMutualList();
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
    // await FirebaseFirestore.instance
    //     .collection('users')
    //     .doc(blockedUser)
    //     .collection('blocked_by')
    //     .doc(current)
    //     .set({
    //
    //   'muted': messagesValue,
    // }, SetOptions(merge: true));
    await FirebaseFirestore.instance
        .collection('users')
        .doc(current)
        .collection('blocked_by')
        .doc(blockedUser)
        .set({
      'muted': messagesValue,
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
      print("$isBlocked -> $blockedBy");
      return {
        'blocked': isBlocked,
        'done_by': blockedBy,
      };
    } else {
      return {};
    }
  }
}
