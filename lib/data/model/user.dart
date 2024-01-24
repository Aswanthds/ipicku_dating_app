import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String? uid;
  String? name;
  int? age;
  String? gender;
  String? email;
  String? bio;
  String? photoPath;
  DateTime? dob;
  Timestamp? created;
  GeoPoint? location;
  int? minAge, maxAge;
  List<dynamic>? userPhotos;
  List<dynamic>? interests;

  UserModel(
      {this.uid,
      this.name,
      this.gender,
      this.email,
      this.photoPath,
      this.created,
      this.location,
      this.age,
      this.bio,
      this.dob,
      this.minAge,
      this.maxAge,
      this.interests,
      this.userPhotos});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      uid: json['uid'],
      name: json['name'],
      age: json['age'],
      gender: json['gender'],
      created: json['created'],
      interests: json['Interests'],
      location: json['location'],
      photoPath: json['photoUrl'],
      userPhotos: json['photos'],
      email: json['email'],
      dob: (json['dob'] as Timestamp).toDate(),
      bio: json['bio'],
      minAge: json['minAge'],
      maxAge: json['maxAge'],
    );
  }
}
