import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class UserRepository {
  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;

  UserRepository({FirebaseAuth? firebaseAuth, GoogleSignIn? googleSignin})
      : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
        _googleSignIn = googleSignin ?? GoogleSignIn();

  Future<void> signInWithCredentials(String email, String password) {
    return _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
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

  Future<void> signUp({required String email, required String password}) async {
    await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

 

  Future<bool> sendPasswordResetEmail(String email) async {
    // final signInmethods = fetchSignInMethods(email);
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
      return true; // Success
    } on FirebaseAuthException catch (error) {
      debugPrint('Error sending password reset email: ${error.code}');
      return false; // Failure
    }
  }

  Future<List<String>> fetchSignInMethods(String email) async {
    return await _firebaseAuth.fetchSignInMethodsForEmail(email);
  }

  Future<void> signOut() async {
    Future.wait([
      _firebaseAuth.signOut(),
      _googleSignIn.signOut(),
    ]);
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
    int? age,
    String? email,
    File? photoPath,
    Timestamp? created,
    GeoPoint? location,
    List<File?>? userPhotos,
    List<String>? interests,
  }) async {
    try {
      // Upload profile photo to Firebase Storage
      final Reference storageRef = FirebaseStorage.instance
          .ref()
          .child('userPhotos')
          .child(userId!)
          .child("profile_pic.png");

      final UploadTask uploadTask = storageRef.putFile(photoPath!);
      final TaskSnapshot storageSnapshot = await uploadTask;
      final String photoUrl = await storageSnapshot.ref.getDownloadURL();

      // Save user data to Firestore
      final CollectionReference usersCollection =
          FirebaseFirestore.instance.collection('users');

      // Check if the user already exists
      final DocumentSnapshot userDoc = await usersCollection.doc(userId).get();

      if (userDoc.exists) {
        // Update user data if the user exists
        await usersCollection.doc(userId).update({
          'photoUrl': photoUrl,
          'name': name,
          'location': location,
          'gender': gender,
          'age': age,
          'email': email,
          'created': created,
        });
      } else {
        // Create a new user if the user doesn't exist
        await usersCollection.doc(userId).set({
          'uid': userId,
          'photoUrl': photoUrl,
          'name': name,
          'location': location,
          'gender': gender,
          'age': age,
          'email': email,
          'created': created,
        });
      }
      String photoPrefix = userId.substring(userId.length - 4);

      // Loop through the user photos and upload each one to Firebase Storage
      for (int i = 0; i < userPhotos!.length; i++) {
        File? photo = userPhotos[i];

        // Construct a unique name for the photo using the generated prefix and a picture number
        String photoName = '$photoPrefix-pic$i.png';

        final Reference storageRef = FirebaseStorage.instance
            .ref()
            .child('userPhotos')
            .child(userId)
            .child(photoName);

        final UploadTask uploadTask = storageRef.putFile(photo!);
        await uploadTask;
        final String photoUrl = await storageRef.getDownloadURL();

        // Save the photo URL to Firestore or perform any other necessary actions
        // Example: Save photo URL to a user's document in the users collection
        await usersCollection.doc(userId).update({
          'photos': FieldValue.arrayUnion([photoUrl]),
        });
      }
      for (int i = 0; i < interests!.length; i++) {
        String interest = interests[i].trim();
        await usersCollection.doc(userId).update({
          'interests': FieldValue.arrayUnion([interest]),
        });
      }
    } catch (e) {
      debugPrint('Error during profile setup: $e');
      // Handle errors (show a message to the user, log the error, etc.)
      rethrow; // Rethrow the error to let the calling code handle it
    }
  }
}
