import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ipicku_dating_app/data/repositories/user_repositories.dart';
import 'package:geoflutterfire2/geoflutterfire2.dart';

CollectionReference usersCollection =
    FirebaseFirestore.instance.collection('users');
final geo = GeoFlutterFire();

class MatchesRepository {
  final UserRepository userRepository = UserRepository();
  MatchesRepository();

  Stream<QuerySnapshot> getMatchedList(String userId) {
    return usersCollection.doc(userId).collection('matchedList').snapshots();
  }

  Stream<QuerySnapshot> getSelectedList(String userId) {
    return usersCollection.doc(userId).collection('selectedList').snapshots();
  }

  Future selectUser(
    currentUserId,
    selectedUserId,
  ) async {
    //deleteUser(currentUserId, selectedUserId);

    await usersCollection
        .doc(currentUserId)
        .collection('matchedList')
        .doc(selectedUserId)
        .set({
      'selectedUserId': selectedUserId,
      'timestamp': FieldValue.serverTimestamp(),
    });

    // return await _firestore
    //     .collection('users')
    //     .document(selectedUserId)
    //     .collection('matchedList')
    //     .document(currentUserId)
    //     .setData({
    //   'name': currentUserName,
    //   'photoUrl': currentUserPhotoUrl,
    // });
  }

  Future<String> getCurrentUserGender(String userId) async {
    DocumentReference userDocRef =
        FirebaseFirestore.instance.collection('users').doc(userId);

    DocumentSnapshot userDocSnapshot = await userDocRef.get();
    final data = userDocSnapshot.data() as Map<String, dynamic>;

    String userGender = data['gender'];
    return userGender;
  }

  Future<List<Map<String, dynamic>>> getRandomUserProfile(String userId) async {
    try {
      var currentUserGender = await getCurrentUserGender(userId);

      final String oppositeGender =
          currentUserGender.toLowerCase() == 'female' ? 'Male' : 'Female';

      final Query query = FirebaseFirestore.instance
          .collection('users')
          .where('gender', isEqualTo: oppositeGender);

      final QuerySnapshot querySnapshot = await query.get();

      if (querySnapshot.docs.isEmpty) {
        debugPrint('No matching profiles found.');
        return [];
      }

      // Return a list of all profiles with the opposite gender
      return querySnapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
    } catch (error) {
      debugPrint("Error fetching profiles: $error");
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> getRecommendedProfiles() async {
    try {
      // Fetch maximum and minimum age from Firestore

      String? currentGender =
          await getCurrentUserGender(await UserRepository().getUser());

      // Fetch profiles within the specified age range
      final oppositeGender =
          currentGender.toLowerCase() == 'male' ? 'Female' : 'Male';

      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await FirebaseFirestore.instance
              .collection('users')
              .where('gender', isEqualTo: oppositeGender)
              .get();

      // Convert GeoPoint to Map<String, dynamic>
      List<Map<String, dynamic>> profiles = querySnapshot.docs.map((doc) {
        Map<String, dynamic> profileData = doc.data();
        GeoPoint? location = doc.data()['location'];
        profileData['location'] = {
          'latitude': location?.latitude ?? 0.0,
          'longitude': location?.longitude ?? 0.0,
        };
        return profileData;
      }).toList();

      return profiles;
    } catch (e) {
      debugPrint("Error fetching recommended profiles: $e");
      return [];
    }
  }
}
