// ignore_for_file: avoid_print

import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ipicku_dating_app/data/model/user.dart';
import 'package:ipicku_dating_app/data/repositories/matches_repo.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserRepository {
  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;

  UserRepository({FirebaseAuth? firebaseAuth, GoogleSignIn? googleSignin})
      : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
        _googleSignIn = googleSignin ?? GoogleSignIn();

  Future<void> signInWithCredentials(String email, String password) async {
    _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    await storeDeviceToken();
  }

  Future<UserCredential?> signInwithGoogle() async {
    try {
      final GoogleSignInAccount? googleSignInAccount =
          await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount!.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      return await _firebaseAuth.signInWithCredential(credential);
    } catch (e) {
      debugPrint("error $e");
      return null;
    }
  }

  Future<void> sentResetEmail(String email) async {
    return await _firebaseAuth.sendPasswordResetEmail(email: email);
  }

  Future<bool> isFirstTime(String userId) async {
    late bool exist;
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .get()
        .then((user) {
      exist = user.exists;
    });

    return exist;
  }

  Future<bool> isProfileSet(String userId) async {
    late bool isSet;
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .get()
        .then((userDoc) {
      // Check if the profile data is set, adjust this according to your data structure
      isSet =
          userDoc.exists && userDoc['name'] != null && userDoc['email'] != null;
    });

    return isSet;
  }

  Future<void> signUp({required String email, required String password}) async {
    await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<bool> sendPasswordResetEmail(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
      return true;
    } on FirebaseAuthException catch (error) {
      debugPrint('Error sending password reset email: ${error.code}');
      return false;
    }
  }

  Future<List<String>> fetchSignInMethods(String email) async {
    return await _firebaseAuth.fetchSignInMethodsForEmail(email);
  }

  Future<void> signOut() async {
    _firebaseAuth.signOut();
    _googleSignIn.signOut();
  }

  Future<bool> isSignedIn() async {
    final currentUser = _firebaseAuth.currentUser;
    return currentUser != null;
  }

  Future<String> getUser() async {
    return (_firebaseAuth.currentUser!).uid;
  }

  Future<String?> getUserEmail() async {
    return (_firebaseAuth.currentUser!).email;
  }

  Future<void> profileSetup({
    String? userId,
    String? name,
    String? gender,
    String? bio,
    int? age,
    String? email,
    File? photoPath,
    Timestamp? created,
    DateTime? dob,
    GeoPoint? location,
  }) async {
    try {
      final Reference storageRef = FirebaseStorage.instance
          .ref()
          .child('userPhotos')
          .child(userId!)
          .child("profile_pic.png");

      final UploadTask uploadTask = storageRef.putFile(photoPath!);
      final TaskSnapshot storageSnapshot = await uploadTask;
      final String photoUrl = await storageSnapshot.ref.getDownloadURL();

      final CollectionReference usersCollection =
          FirebaseFirestore.instance.collection('users');

      final DocumentSnapshot userDoc = await usersCollection.doc(userId).get();
      final dataToken = await FirebaseMessaging.instance.getToken();
      if (userDoc.exists) {
        await usersCollection.doc(userId).update({
          'photoUrl': photoUrl,
          'name': name,
          'location': location,
          'gender': gender,
          'age': age,
          'email': email,
          'created': created,
          'dob': dob,
          'bio': bio,
          'deviceToken': dataToken
        });
      } else {
        await usersCollection.doc(userId).set({
          'uid': userId,
          'photoUrl': photoUrl,
          'name': name,
          'location': location,
          'gender': gender,
          'age': age,
          'email': email,
          'created': created,
          'dob': dob,
          'bio': bio,
          'deviceToken': dataToken
        });
      }
    } catch (e) {
      debugPrint('Error during profile setup: $e');

      rethrow;
    }
  }

  Future<List<UserModel>> get() async {
    List<UserModel> list = [];

    try {
      final users = await FirebaseFirestore.instance.collection('users').get();

      for (var element in users.docs) {
        list.add(UserModel.fromJson(element.data()));
      }

      return list;
    } on FirebaseException catch (e) {
      debugPrint("Failed with error ${e.code} : ${e.message}");
      return list;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<UserModel?> getUserData() async {
    try {
      final userId = await getUser();
      final users = FirebaseFirestore.instance.collection('users').doc(userId);

      final data = await users.get();

      return UserModel.fromJson(data.data() ?? {});
    } catch (e) {
      debugPrint("$e");
      return null;
    }
  }

  Future<Map<String, dynamic>?> getUserMap() async {
    try {
      final userId = await getUser();
      final users = FirebaseFirestore.instance.collection('users').doc(userId);

      final data = await users.get();

      return data.data();
    } catch (e) {
      debugPrint("$e");
      return null;
    }
  }

  Future<Map<String, dynamic>?> getUserMapAlongwithBloc(
      String selectedUserId) async {
    try {
      final userId = await getUser();
      final users = FirebaseFirestore.instance.collection('users').doc(userId);

      final data = await users.get();
      var finaldata = {...data.data() ?? {}};

      // Fetch blocked_by data for the selected user
      final blockedData = await users.collection("blocked_by").get();
      final data2 = blockedData.docs
          .where((element) => element.id == selectedUserId)
          .map((e) => e.data())
          .first;

      // Check if blocked data for the selected user exists
      if (data2.containsValue(selectedUserId)) {
        return {...finaldata, ...data2};
      } else {
        // If blocked data doesn't exist, return dummy data
        return {
          ...finaldata,
          'blocked': false,
          'done_by':
              selectedUserId, // Use the ID of the selected user as done_by
        };
      }
    } catch (e) {
      debugPrint("$e");
      return null;
    }
  }

  Future<void> uploadImageToStorage(
      XFile imageFile, int index, String field) async {
    try {
      final userId = await getUser();

      String photoPrefix = userId.substring(userId.length - 4).toLowerCase();
      String photoName = '$photoPrefix-$field$index.png';

      final storageRef = FirebaseStorage.instance
          .ref()
          .child('userPhotos')
          .child(userId)
          .child(photoName);
      await storageRef.putFile(File(imageFile.path));
      // final downloadURL = await storageRef.getDownloadURL();
      // return downloadURL;
    } catch (e) {
      debugPrint('Error uploading image: $e');
    }
  }

  Future<String> getProfilePhotoLink(XFile imageFile) async {
    final userId = await getUser();
    String photoPrefix = userId.substring(userId.length - 4).toLowerCase();
    final storageRef = FirebaseStorage.instance
        .ref()
        .child('userPhotos')
        .child(userId)
        .child('$photoPrefix-profile_pic4.png');
    await storageRef.putFile(File(imageFile.path));

    return storageRef.getDownloadURL();
  }

  Future<List<String>> getImageURLsFromStorage() async {
    try {
      final userId = await getUser();
      final storageRef =
          FirebaseStorage.instance.ref().child('userPhotos').child(userId);
      final ListResult result = await storageRef.listAll();
      final List<String> imageURLs = [];

      for (final item in result.items) {
        if (!item.name.contains("profile")) {
          final downloadURL = await item.getDownloadURL();
          imageURLs.add(downloadURL);
        }
      }

      return imageURLs;
    } catch (e) {
      debugPrint('Error getting image URLs: $e');
      return [];
    }
  }

  Future<void> updateFirestoreWithImageURLs(List<String> imageURLs) async {
    try {
      final userId = await getUser();
      final userDocRef =
          FirebaseFirestore.instance.collection('users').doc(userId);

      await userDocRef.update({
        'photos': imageURLs,
      });
    } catch (e) {
      debugPrint('Error updating Firestore: $e');
    }
  }

  Future<void> deleteAccount() async {
    try {
      final userId = await getUser();
      DocumentReference userRef =
          FirebaseFirestore.instance.collection('users').doc(userId);
      await userRef.delete();

      FirebaseStorage.instance.ref().child('userPhotos').child(userId).delete();
    } catch (e) {
      throw Exception("Unable to delete user account: $e");
    }
  }

  Future<void> deleteUserAccount() async {
    try {
      // Get the current user ID
      final userId = FirebaseAuth.instance.currentUser!.uid;

      // Reference to Firestore document
      DocumentReference userRef =
          FirebaseFirestore.instance.collection('users').doc(userId);

      // Reference to Firebase Storage folder
      Reference userImagesRef =
          FirebaseStorage.instance.ref().child('userPhotos').child(userId);

      // Delete user data from Firestore
      await userRef.delete();

      // Delete all images in the Firebase Storage folder
      await userImagesRef.listAll().then((result) async {
        await Future.forEach(result.items, (Reference item) async {
          await item.delete();
        });
      });

      // Sign out from Google if signed in using Google Sign-In
      if (_firebaseAuth.currentUser != null) {
        await _firebaseAuth.currentUser?.delete();
        await _googleSignIn.signOut();
      }
    } on FirebaseAuthException catch (e) {
      debugPrint(e.toString());

      if (e.code == "requires-recent-login") {
        // Handle the case where re-authentication is required
        await _reauthenticateAndDelete();
        await _firebaseAuth.currentUser?.delete();
        await _googleSignIn.signOut();
      } else {
        // Handle other Firebase exceptions
      }
    } catch (e) {
      debugPrint(e.toString());

      // Handle general exception
    }
  }

  Future<void> _reauthenticateAndDelete() async {
    try {
      final providerData = _firebaseAuth.currentUser?.providerData.first;

      if (GoogleAuthProvider().providerId == providerData!.providerId) {
        await _firebaseAuth.currentUser!
            .reauthenticateWithProvider(GoogleAuthProvider());
      }

      await _firebaseAuth.currentUser?.delete();
    } catch (e) {
      // Handle exceptions
    }
  }

  Future<UserCredential?> googleSignUp() async {
    try {
      final GoogleSignInAccount? googleSignInAccount =
          await _googleSignIn.signIn();
      final GoogleSignInAuthentication? googleSignInAuthentication =
          await googleSignInAccount?.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication?.accessToken,
        idToken: googleSignInAuthentication?.idToken,
      );

      return await _firebaseAuth.signInWithCredential(credential);
    } catch (error) {
      debugPrint('Error signing in with Google: $error');
      return null;
    }
  }

  Future<GeoPoint?> getUserLocation() async {
    String userId = await getUser();
    DocumentSnapshot userSnapshot =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();

    // Check if the user document exists
    if (userSnapshot.exists) {
      // Retrieve the GeoPoint from the 'location' field
      GeoPoint geoPoint = userSnapshot['location'];

      return geoPoint;

      // Extract latitude and longitude
      // double latitude = geoPoint.latitude;
      // double longitude = geoPoint.longitude;

      // debugPrint('User Latitude: $latitude, Longitude: $longitude');
    } else {
      debugPrint('User not found or document does not exist.');
      return null;
    }
  }

  Future<String> getSelectedUserIdToken(String userId) async {
    final tokenSnapshot = await usersCollection.doc(userId).get();
    if (!tokenSnapshot.data()!.containsKey('deviceToken')) {
      await storeDeviceToken();
      final userData = tokenSnapshot.data() as Map<String, dynamic>;
      return userData['deviceToken'] as String;
    } else {
      final userData = tokenSnapshot.data() as Map<String, dynamic>;
      return userData['deviceToken'] as String;
    }
  }

  Future<void> storeDeviceToken() async {
    final id = await getUser();

    await FirebaseMessaging.instance.getToken().then((token) async {
      await usersCollection.doc(id).update({"deviceToken": token});
      debugPrint('My token is $token');
    });
  }

  void setStatus(bool status) async {
    final userId = await getUser();
    debugPrint(status.toString());
    await usersCollection
        .doc(userId)
        .update({'status': status, 'lastActive': Timestamp.now()});
  }

  Future<Map<String, dynamic>> getNotificationsValue() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final picks = prefs.getBool("picks") ?? false;
    final messages = prefs.getBool("messages") ?? false;
    final recommendations = prefs.getBool("recomendations") ?? false;

    return {
      'picks': picks,
      'messages': messages,
      'recomendations': recommendations,
    };
  }

  Future<void> updateNotificationPreferences(String key, bool value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    usersCollection.doc(await getUser()).update({'notifications_$key':value});
    await prefs.setBool(key, value);
  }
}
/*

firebase.auth()
    .signInWithEmailAndPassword('you@domain.example', 'correcthorsebatterystaple')
    .then(function(userCredential) {
        userCredential.user.updateEmail('newyou@domain.example')
    })

    */