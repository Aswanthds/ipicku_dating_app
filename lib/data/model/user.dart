import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String? uid;
  String? name;
  String? gender;
  String? email;
  String? photoPath;
  Timestamp? created;
  GeoPoint? location;

  List<String>? userPhotos;
  List<String>? interests;

  UserModel(
      {this.uid,
      this.name,
      this.gender,
      this.email,
      this.photoPath,
      this.created,
      this.location,
      this.interests,
      this.userPhotos});

  //     factory UserModel.fromSnapshot(DocumentSnapshot snapshot) {
  //   Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;

  //   return UserModel(
  //     uid: snapshot.id,
  //     name: data['displayName'] ?? '',
  //     email: data['email'] ?? '',
  //     created: data['created'] ,
  //     gender:data['gender'] ,
  //     interests: data['interests'] ,
  //     location: data['location']  ,
  //     photoPath:  data['photoPath'] ,
  //     userPhotos: data['userPhotos']  ,
  //   );
  // }
}
