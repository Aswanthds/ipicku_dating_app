import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ipicku_dating_app/data/model/user.dart';
import 'package:ipicku_dating_app/data/repositories/user_repositories.dart';

class FirebaseRepository {
  //final FirebaseStorage _firebase = FirebaseStorage.instance;
  final UserRepository repository;
  FirebaseRepository({required this.repository});

  Future<UserModel?> getData() async {
    try {
      final userId = await repository.getUser();

      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      if (userSnapshot.exists) {
        Map<String, dynamic> data = userSnapshot.data() as Map<String, dynamic>;
        return UserModel(
          uid: userSnapshot.id,
          name: data['name'],
          email: data['email'],
          gender: data['gender'],
          interests: data['interests'],
          location: data['location'],
          photoPath: data['photoPath'],
          userPhotos: data['userPhotos'],
        );
      } else {
        print('User not found');
        return null;
      }
    } catch (e) {
      debugPrint('Error fetching user data: $e');
      return null;
    }
  }
}
