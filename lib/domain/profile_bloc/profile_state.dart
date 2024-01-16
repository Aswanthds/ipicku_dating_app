import 'package:flutter/material.dart';

@immutable
class ProfileState {
  // final bool isPhotoEmpty;
  // final bool isNameEmpty;
  // final bool isAgeEmpty;
  // final bool isGenderEmpty;
  // final bool isLocationEmpty;
  final bool isFailure;
  final bool isSubmitting;
  final bool isSuccess;
  final bool isPicsEmpty;
  // bool get isFormValid =>
  //     isPhotoEmpty && isNameEmpty && isAgeEmpty && isGenderEmpty;

  const ProfileState({
    // required this.isPhotoEmpty,
    // required this.isNameEmpty,
    // required this.isAgeEmpty,
    // required this.isGenderEmpty,
    // required this.isLocationEmpty,
    required this.isFailure,
    required this.isSubmitting,
    required this.isSuccess,
    required this.isPicsEmpty,
  });

  factory ProfileState.empty() {
    return const ProfileState(
      isFailure: false,
      isSuccess: false,
      isSubmitting: false,
      // isNameEmpty: false,
      // isAgeEmpty: false,
      // isGenderEmpty: false,
      // isLocationEmpty: false,
      // isPhotoEmpty: false,
      isPicsEmpty: false,
    );
  }

  factory ProfileState.loading() {
    return const ProfileState(
      isFailure: false,
      isSuccess: false,
      isSubmitting: true,
      isPicsEmpty: false,
      // isNameEmpty: false,
      // isAgeEmpty: false,
      // isGenderEmpty: false,
      // isLocationEmpty: false,
      //     isPhotoEmpty: false,
    );
  }

  factory ProfileState.failure() {
    return const ProfileState(
      isFailure: true,
      isSuccess: false,
      isSubmitting: false,
      isPicsEmpty: false,
      // isNameEmpty: false,
      // isAgeEmpty: false,
      // isGenderEmpty: false,
      // isLocationEmpty: false,
      //   isPhotoEmpty: false,
    );
  }

  factory ProfileState.success() {
    return const ProfileState(
      isFailure: false,
      isSuccess: true,
      isSubmitting: false,
      isPicsEmpty: false,
      // isNameEmpty: false,
      // isAgeEmpty: false,
      // isGenderEmpty: false,
      // isLocationEmpty: false,
      //   isPhotoEmpty: false,
    );
  }

  ProfileState update({
    bool? isPhotoEmpty,
    bool? isNameEmpty,
    bool? isAgeEmpty,
    bool? isGenderEmpty,
    bool? isLocationEmpty,
    bool? isPicsEmpty
  }) {
    return copyWith(
      isFailure: false,
      isSuccess: false,
      isSubmitting: false,
      isPicsEmpty: isPicsEmpty,
      // isPhotoEmpty: isPhotoEmpty,
      // isNameEmpty: isNameEmpty,
      // isAgeEmpty: isAgeEmpty,
      // isGenderEmpty: isGenderEmpty,
      // isLocationEmpty: isLocationEmpty,
    );
  }

  ProfileState copyWith({
    // bool? isPhotoEmpty,
    // bool? isNameEmpty,
    // bool? isAgeEmpty,
    // bool? isGenderEmpty,
    // bool? isLocationEmpty,
    bool? isSubmitting,
    bool? isSuccess,
    bool? isFailure,
    bool? isPicsEmpty,
  }) {
    return ProfileState(
      // isPhotoEmpty: isPhotoEmpty ?? this.isPhotoEmpty,
      // isNameEmpty: isNameEmpty ?? this.isNameEmpty,
      // isLocationEmpty: isLocationEmpty ?? this.isLocationEmpty,
      // isGenderEmpty: isGenderEmpty ?? this.isGenderEmpty,
      // isAgeEmpty: isAgeEmpty ?? this.isAgeEmpty,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isSuccess: isSuccess ?? this.isSuccess,
      isFailure: isFailure ?? this.isFailure,
      isPicsEmpty: isPicsEmpty ?? this.isPicsEmpty,
    );
  }
}
