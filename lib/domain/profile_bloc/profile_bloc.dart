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
  ProfileBloc(this.userRepository) : super( ProfileStateEmpty()) {
    on<Submitted>(_submitted);
    //on<PhotosChanged>(_photosChanged);

  }

  FutureOr<void> _submitted(Submitted event, Emitter<ProfileState> emit) async {
    emit( ProfileStateLoading());
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
        // bio: event.bio ?? '',
      //  interests: event.interests,
      
        created: event.createdNow,
      );
      emit( ProfileStateSuccess());
    } catch (e) {
      emit( ProfileStateFailure());
    }
  }

}
