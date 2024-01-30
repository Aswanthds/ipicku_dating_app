import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ipicku_dating_app/data/repositories/user_repositories.dart';
import 'package:geoflutterfire2/geoflutterfire2.dart';

final usersCollection = FirebaseFirestore.instance.collection('users');
final geo = GeoFlutterFire();

class MatchesRepository {
  final UserRepository userRepository = UserRepository();
  MatchesRepository();

  // Stream<QuerySnapshot> getMatchedList(String userId) {
  //   return usersCollection.doc(userId).collection('matchedList').snapshots();
  // }

  // Stream<QuerySnapshot> getSelectedList(String userId) {
  //   return usersCollection.doc(userId).collection('selectedList').snapshots();
  // }
  Future<List<Map<String, dynamic>>> getMatchedList(String userId) async {
    try {
      final snapshot = await usersCollection
          .doc(userId)
          .collection('myPicks')
          .orderBy('timestamp', descending: true)
          .get();

      List<Map<String, dynamic>> matchedList = [];

      for (DocumentSnapshot document in snapshot.docs) {
        String matchedUserId = document['selectedUserId'];
        DocumentSnapshot<Map<String, dynamic>> userSnapshot =
            await usersCollection.doc(matchedUserId).get();

        if (userSnapshot.exists) {
          Map<String, dynamic> userData = userSnapshot.data()!;
          userData['timestamp'] = document['timestamp'];
          matchedList.add(userData);
        }
      }

      return matchedList;
    } catch (e) {
      debugPrint("Error fetching matched users: $e");
      rethrow;
    }
  }

  Future selectUser(
    currentUserId,
    selectedUserId,
  ) async {
    //deleteUser(currentUserId, selectedUserId);

    await usersCollection
        .doc(currentUserId)
        .collection('myPicks')
        .doc(selectedUserId)
        .set({
      'selectedUserId': selectedUserId,
      'timestamp': FieldValue.serverTimestamp(),
    });

    await usersCollection
        .doc(selectedUserId)
        .collection('whoPicksMe')
        .doc(currentUserId)
        .set({
      'selectedby': currentUserId,
      'timestamp': FieldValue.serverTimestamp(),
    });
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

      // Combined query with a single 'where' clause
      final Query query = FirebaseFirestore.instance
          .collection('users')
          .where('gender', isEqualTo: oppositeGender);

      final QuerySnapshot querySnapshot = await query.get();

      if (querySnapshot.docs.isEmpty) {
        debugPrint('No matching profiles found.');
        return [];
      }

      final array = querySnapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
      array.shuffle();

      return array;
    } catch (error) {
      debugPrint("Error fetching profiles: $error");
      // Handle the error gracefully, e.g., display an error message to the user
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

      // Convert GeoPoint to GeoPoint
      List<Map<String, dynamic>> profiles = querySnapshot.docs.map((doc) {
        Map<String, dynamic> profileData = doc.data();
        GeoPoint? location = doc.data()['location'];
        profileData['location'] = location;
        return profileData;
      }).toList();

      // Debug prints to check fetched profiles
      for (var profile in profiles) {
        debugPrint("Fetched profile: $profile['name']");
      }

      return profiles;
    } catch (e) {
      debugPrint("Error fetching recommended profiles: $e");
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> getProfilesWithCommonInterestsAndGender(
      String userId) async {
    try {
      // Fetch the user's interests and gender from Firestore
      DocumentSnapshot<Map<String, dynamic>> userSnapshot =
          await usersCollection.doc(userId).get();

      if (!userSnapshot.exists) {
        debugPrint('User not found');
        return [];
      }

      List<dynamic> userInterests = userSnapshot.data()?['Interests'] ?? [];
      String? userGender = userSnapshot.data()?['gender'];

      if (userInterests.isEmpty || userGender == null) {
        debugPrint('User has no interests or gender information');
        return [];
      }
      debugPrint(userInterests.length.toString());
      // Query profiles with common interests and opposite gender
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await FirebaseFirestore.instance
              .collection('users')
              .where('Interests', arrayContainsAny: userInterests)
              .where('gender',
                  isEqualTo: userGender == 'Male' ? 'Female' : 'Male')
              .get();

      if (querySnapshot.docs.isEmpty) {
        debugPrint('No matching profiles found.');
        return [];
      }

      List<Map<String, dynamic>> profiles =
          querySnapshot.docs.map((doc) => doc.data()).toList();

      return profiles;
    } catch (e) {
      debugPrint("Error fetching profiles: $e");
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> getSelectedList(
      String currentUserId) async {
    try {
      final snapshot = await usersCollection
          .doc(currentUserId)
          .collection('whoPicksMe')
          .orderBy('timestamp', descending: true)
          .get();

      List<Map<String, dynamic>> matchedList = [];

      for (DocumentSnapshot document in snapshot.docs) {
        String matchedUserId = document['selectedby'];
        DocumentSnapshot<Map<String, dynamic>> userSnapshot =
            await usersCollection.doc(matchedUserId).get();

        if (userSnapshot.exists) {
          Map<String, dynamic> userData = userSnapshot.data()!;
          userData['timestamp'] = document['timestamp'];
          matchedList.add(userData);
        }
      }

      return matchedList;
    } catch (e) {
      debugPrint("Error fetching matched users: $e");
      rethrow;
    }
  }

  Future<List<Map<String, dynamic>>> getMutualList() async {
    final userId = await UserRepository().getUser();

    final userSnapshot = await usersCollection
        .doc(userId)
        .collection('myPicks')
        .orderBy('timestamp', descending: true)
        .get();
    final userSnapshot2 = await usersCollection
        .doc(userId)
        .collection('whoPicksMe')
        .orderBy('timestamp', descending: true)
        .get();
    List<Map<String, dynamic>> userDataList = [];

    // Extract document IDs from both collections
    Set<String> documentIds1 =
        Set<String>.from(userSnapshot.docs.map((doc) => doc.id));
    Set<String> documentIds2 =
        Set<String>.from(userSnapshot2.docs.map((doc) => doc.id));

    // Find the common document IDs
    Set<String> commonDocumentIds = documentIds1.intersection(documentIds2);
    debugPrint(commonDocumentIds.join(' - '));
    // Fetch user data for the common document IDs
    for (String documentId in commonDocumentIds) {
      DocumentSnapshot<Map<String, dynamic>> userSnapshot =
          await usersCollection.doc(documentId).get();
      final data = userSnapshot.data();
      if (data != null) {
        userDataList.add(data);
      }
    }

    return userDataList;
  }
}
