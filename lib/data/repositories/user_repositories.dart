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

/*


*/
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

  Future<void> profileSetup(
      {File? photo,
      String? userId,
      String? name,
      String? gender,
      String? email,
      int? age,
      DateTime? created,
      GeoPoint? location}) async {
    //StorageUploadTask storageUploadTask;
    final Reference storageRef = FirebaseStorage.instance
        .ref()
        .child('userPhotos')
        .child(userId!)
        .child("profile_pic.png");

    final UploadTask uploadTask = storageRef.putFile(photo!);
    final TaskSnapshot storageSnapshot = await uploadTask;
    final String photoUrl = await storageSnapshot.ref.getDownloadURL();

    // Save user data to Firestore
    final CollectionReference usersCollection =
        FirebaseFirestore.instance.collection('users');

    await usersCollection.doc(userId).set(
      {
        'uid': userId,
        'photoUrl': photoUrl,
        'name': name,
        'location': location,
        'gender': gender,
        'age': age,
        'email': email,
        'created': created,
      },
    );
  }
}
