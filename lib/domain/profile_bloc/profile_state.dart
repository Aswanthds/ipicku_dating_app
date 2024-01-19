import 'package:flutter/material.dart';

@immutable
class ProfileState {
  final bool isFailure;
  final bool isSubmitting;
  final bool isSuccess;
  final bool isPicsEmpty;

  const ProfileState(
      {required this.isFailure,
      required this.isSubmitting,
      required this.isSuccess,
      required this.isPicsEmpty});

  ProfileState copyWith({
    bool? isSubmitting,
    bool? isSuccess,
    bool? isFailure,
    bool? isPicsEmpty,
  }) {
    return ProfileState(
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isSuccess: isSuccess ?? this.isSuccess,
      isFailure: isFailure ?? this.isFailure,
      isPicsEmpty: isPicsEmpty ?? this.isPicsEmpty,
    );
  }

  ProfileState update(
      {bool? isPhotoEmpty,
      bool? isNameEmpty,
      bool? isAgeEmpty,
      bool? isGenderEmpty,
      bool? isLocationEmpty,
      bool? isPicsEmpty}) {
    return copyWith(
      isFailure: false,
      isSuccess: false,
      isSubmitting: false,
      isPicsEmpty: isPicsEmpty,
    );
  }
}

class ProfileStateEmpty extends ProfileState {
  const ProfileStateEmpty()
      : super(
            isSubmitting: true,
            isSuccess: false,
            isFailure: false,
            isPicsEmpty: false);
}

class ProfileStateLoading extends ProfileState {
  const ProfileStateLoading()
      : super(
            isSubmitting: true,
            isSuccess: false,
            isFailure: false,
            isPicsEmpty: false);
}

class ProfileStateFailure extends ProfileState {
  const ProfileStateFailure()
      : super(
            isSubmitting: false,
            isSuccess: false,
            isFailure: true,
            isPicsEmpty: false);
}

class ProfileStateSuccess extends ProfileState {
  const ProfileStateSuccess()
      : super(
            isSubmitting: false,
            isSuccess: true,
            isFailure: false,
            isPicsEmpty: false);
}
