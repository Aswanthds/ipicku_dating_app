import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class VideoRepository {
  static Future<String> getUniqueUserId() async {
    String? deviceID;
    final deviceInfo = DeviceInfoPlugin();
    if (Platform.isIOS) {
      final iosDeviceInfo = await deviceInfo.iosInfo;
      deviceID = iosDeviceInfo.identifierForVendor; // unique ID on iOS
    } else if (Platform.isAndroid) {
      final androidDeviceInfo = await deviceInfo.androidInfo;
      deviceID = androidDeviceInfo.id;
      debugPrint("Happy ID $deviceID"); // unique ID on Android
    }

    if (deviceID != null && deviceID.length < 4) {
      if (Platform.isAndroid) {
        deviceID += '_android';
      } else if (Platform.isIOS) {
        deviceID += '_ios___';
      }
    }
    if (Platform.isAndroid) {
      deviceID ??= 'flutter_user_id_android';
    } else if (Platform.isIOS) {
      deviceID ??= 'flutter_user_id_ios';
    }

    final userID = md5
        .convert(utf8.encode(deviceID!))
        .toString()
        .replaceAll(RegExp(r'[^0-9]'), '');
    return userID.substring(userID.length - 6);
  }

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
