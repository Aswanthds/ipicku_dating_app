import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:ipicku_dating_app/data/repositories/local_notifications.dart';
import 'package:ipicku_dating_app/data/repositories/user_repositories.dart';

final usersCollection = FirebaseFirestore.instance.collection('users');

class MatchesRepository {
  final UserRepository userRepository = UserRepository();
  MatchesRepository();

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

    try {
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

      FirebaseMessaging.instance.getToken().then((token) async {
        // final selectedUserDeviceToken =
        //     await userRepository.getSelectedUserIdToken(selectedUserId);

        // Send notification using Firebase Cloud Messaging API

        debugPrint('Notification sent successfully!');
      });
    } catch (e) {
      debugPrint(e.toString());
    }
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

  // Future<List<Map<String, dynamic>>> getProfilesWithCommonInterestsAndAge(
  //     String userId) async {
  //   try {
  //     // Fetch the user's interests, gender, minAge, and maxAge from Firestore
  //     DocumentSnapshot<Map<String, dynamic>> userSnapshot =
  //         await usersCollection.doc(userId).get();

  //     if (!userSnapshot.exists) {
  //       debugPrint('User not found');
  //       return [];
  //     }

  //     List<dynamic> userInterests = userSnapshot.data()?['Interests'] ?? [];
  //     String? userGender = userSnapshot.data()?['gender'];
  //     int? minAge = userSnapshot.data()?['minAge'];
  //     int? maxAge = userSnapshot.data()?['maxAge'];

  //     if (userInterests.isEmpty ||
  //         userGender == null ||
  //         minAge == null ||
  //         maxAge == null) {
  //       debugPrint('User has missing information');
  //       return [];
  //     }

  //     // Query profiles with common interests, opposite gender, and within age range
  //     QuerySnapshot<Map<String, dynamic>> querySnapshot =
  //         await FirebaseFirestore.instance
  //             .collection('users')
  //             .where('gender',
  //                 isEqualTo: userGender == 'Male' ? 'Female' : 'Male')
  //             .where('age',
  //                 isGreaterThanOrEqualTo: minAge, isLessThanOrEqualTo: maxAge)
  //             .orderBy('age')
  //             .limitToLast(5)
  //             .get();

  //     if (querySnapshot.docs.isEmpty) {
  //       debugPrint('No matching profiles found.');
  //       return [];
  //     }

  //     List<Map<String, dynamic>> profiles =
  //         querySnapshot.docs.map((doc) => doc.data()).toList();

  //     return profiles;
  //   } catch (e) {
  //     debugPrint("Error fetching profiles: $e");
  //     return [];
  //   }
  // }
  Future<Map<String, List<Map<String, dynamic>>>>
      getProfilesWithCommonInterestsAndAge(String userId) async {
    try {
      // Fetch the user's interests, gender, minAge, and maxAge from Firestore
      DocumentSnapshot<Map<String, dynamic>> userSnapshot =
          await usersCollection.doc(userId).get();

      if (!userSnapshot.exists) {
        debugPrint('User not found');
        return {};
      }

      List<dynamic> userInterests = userSnapshot.data()?['Interests'] ?? [];
      String? userGender = userSnapshot.data()?['gender'];

      if (userInterests.isEmpty || userGender == null) {
        debugPrint('User has missing information');
        return {};
      }

      Map<String, List<Map<String, dynamic>>> interestProfiles = {};

      for (var interest in userInterests) {
        QuerySnapshot<Map<String, dynamic>> querySnapshot =
            await FirebaseFirestore.instance
                .collection('users')
                .where('gender',
                    isEqualTo: userGender == 'Male' ? 'Female' : 'Male')
                .where('Interests', arrayContains: interest)
                .get();

        if (querySnapshot.docs.isNotEmpty) {
          interestProfiles[interest] =
              querySnapshot.docs.map((doc) => doc.data()).toList();
        }
      }

      return interestProfiles;
    } catch (e) {
      debugPrint("Error fetching profiles: $e");
      return {};
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
          if ((userData['timestamp'] as Timestamp).toDate().isAfter(
                userData['lastActive'].toDate().subtract(
                      const Duration(
                          minutes: 5), // Adjust the duration as needed
                    ),
              )) {
            NotificationService().showNotification(notification: {
              "title": "New User Picked you",
              "body": "A USer ${userData['name']}"
            });
          }
        }
      }
      debugPrint("data : $matchedList");
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
      final userData = userSnapshot.data();
      if (userData != null) {
        userDataList.add(userData);
        // debugPrint(combinedData['blocked'].toString());
      }
    }

    return userDataList;
  }

  Future<void> deleteMyPickDocument(String userId, String myPickId) async {
    try {
      // Get a reference to the 'myPicks' subcollection document
      final DocumentReference<Map<String, dynamic>> myPickDocRef =
          FirebaseFirestore.instance
              .collection('users')
              .doc(userId)
              .collection('myPicks')
              .doc(myPickId);

      // Delete the document
      await myPickDocRef.delete();

      debugPrint('Document deleted successfully.');
    } catch (e) {
      debugPrint('Error deleting document: $e');
    }
  }

  Future<bool> isUserInPickedList(String targetUserId) async {
    final currentUserId = await UserRepository().getUser();
    final source =
        await usersCollection.doc(currentUserId).collection('myPicks').get();

    return source.docs.any((e) => e.id == targetUserId);
  }
}
