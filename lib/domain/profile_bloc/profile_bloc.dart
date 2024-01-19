import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:ipicku_dating_app/data/model/user.dart';
import 'package:ipicku_dating_app/data/repositories/user_repositories.dart';
import 'package:ipicku_dating_app/domain/profile_bloc/profile_state.dart';

part 'profile_event.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final UserRepository userRepository;
  ProfileBloc(this.userRepository) : super(const ProfileStateEmpty()) {
    on<Submitted>(_submitted);
    //on<PhotosChanged>(_photosChanged);
    on<NameChanged>(_nameChanged);
  }

  FutureOr<void> _submitted(Submitted event, Emitter<ProfileState> emit) async {
    emit(const ProfileStateLoading());
    final uid = await userRepository.getUser();
    final email = await userRepository.getUserEmail();
    try {
      userRepository.profileSetup(
        age: event.age,
        gender: event.gender,
        location: event.location,
        name: event.name,
        photoPath: event.photo,
        email: email,
        userId: uid,
        dob: event.dob,
        bio: event.bio ?? '',
        interests: event.interests,
      
        created: event.createdNow,
      );
      emit(const ProfileStateSuccess());
    } catch (e) {
      emit(const ProfileStateFailure());
    }
  }

  // FutureOr<void> _photosChanged(
  //     PhotosChanged event, Emitter<ProfileState> emit)async {
  //   //emit(state.update(isPicsEmpty: event.photos.isEmpty));
  //   try {
  //     final uid = await userRepository.getUser();
  //   final docRef = FirebaseFirestore.instance.collection('users').doc(uid);
  //   final currentImages = (await docRef.get()).data()!['images'] as List<dynamic>;

  //   // Upload new images to Cloud Storage (if needed)
  //   // final newImageUrls = await userRepository.getImagesToupload(event.photos);

  //   // Update Firestore with new image URLs
  //  // await docRef.update({'images': newImageUrls});
  //  await userRepository.getImagesToupload(event.photos);

  //   // Fetch updated profile data
  //   final updatedProfileData = await userRepository.getUserData();
  //   yield ProfileStateLoaded(profileData: updatedProfileData);
  // } catch (error) {
  //   yield ProfileStateFailure(error.toString());
  // }
  // }

  FutureOr<void> _nameChanged(NameChanged event, Emitter<ProfileState> emit) {
    emit(state.update(isNameEmpty: event.name == null));
  }
}
