import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String? uid;
  String? firstName;
  String? lastName;
  String? gender;
  String? email;
  String? interestedGender;
  String? photoPath;
  Timestamp? created;
  GeoPoint? location;
  String? password;
  List<String>? userPhotos;
  List<String>? interests;

  UserModel(
      {this.uid,
      this.firstName,
      this.lastName,
      this.gender,
      this.email,
      this.password,
      this.interestedGender,
      this.photoPath,
      this.created,
      this.location,
      this.interests,
      this.userPhotos});
}
