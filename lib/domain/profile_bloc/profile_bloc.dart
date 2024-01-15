import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:ipicku_dating_app/data/repositories/user_repositories.dart';
import 'package:ipicku_dating_app/domain/profile_bloc/profile_state.dart';

part 'profile_event.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final UserRepository userRepository;
  ProfileBloc(this.userRepository) : super(ProfileState.empty()) {
    // on<NameChanged>(_nameChanged);
    // on<AgeChanged>(_ageChanged);
    // on<GenderChanged>(_genderChanged);
    //on<InterestedInChanged>(_interestedChanged);
    //on<LocationChanged>(_locationChanged);
    on<Submitted>(_submitted);
    //on<PhotoChanged>(_photochanged);
  }

  FutureOr<void> _submitted(Submitted event, Emitter<ProfileState> emit) async {
    emit(ProfileState.loading());
    final uid = await userRepository.getUser();
    final email = await userRepository.getUserEmail();
    try {
      userRepository.profileSetup(
        age: event.age,
        gender: event.gender,
        location: event.location,
        name: event.name,
        photo: event.photo,
        email: email ,
        userId: uid,
        created: DateTime.now(),
      );
      emit(ProfileState.success());
    } catch (e) {
      emit(ProfileState.failure());
    }
  }

  // FutureOr<void> _locationChanged(
  //     LocationChanged event, Emitter<ProfileState> emit) {
  //   emit(state.update(isLocationEmpty: event.location == null));
  // }

  // FutureOr<void> _genderChanged(
  //     GenderChanged event, Emitter<ProfileState> emit) {
  //       emit(state.update(isGenderEmpty: event.gender == null));
  //     }

  // FutureOr<void> _ageChanged(AgeChanged event, Emitter<ProfileState> emit) {
  //   emit(state.update(isAgeEmpty: event.age == null));
  // }

  // FutureOr<void> _nameChanged(NameChanged event, Emitter<ProfileState> emit) {
  //   emit(state.update(isNameEmpty: event.name == null));
  // }

  // FutureOr<void> _photochanged(PhotoChanged event, Emitter<ProfileState> emit) {
  //   emit(state.update(isPhotoEmpty: event.photo == null));
  // }
}
