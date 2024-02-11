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
      return MatchesRepository().getMutualList();
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

  Future<void> addToBlockedList(String blockedUser) async {
    final current = FirebaseAuth.instance.currentUser!.uid;
    await FirebaseFirestore.instance
        .collection('users')
        .doc(blockedUser)
        .collection('blocked_by')
        .doc(current)
        .set({
      'done_by': current,
      'user_notifications': false,
      'user_messages': false,
    });
  }

  Future<void> addToMutedList(String blockedUser) async {
    final current = FirebaseAuth.instance.currentUser!.uid;
    await FirebaseFirestore.instance
        .collection('users')
        .doc(blockedUser)
        .collection('blocked_by')
        .doc(current)
        .set({
      'done_by': current,
      'user_messages': false,
    });
  }
}
