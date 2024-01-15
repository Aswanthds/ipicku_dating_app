part of 'profile_bloc.dart';

sealed class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object> get props => [];
}

// class NameChanged extends ProfileEvent {
//   final String? name;

//   const NameChanged(this.name);
//   @override
//   List<Object> get props => [name!];
// }

// class AgeChanged extends ProfileEvent {
//   final DateTime? age;

//   const AgeChanged(this.age);
//   @override
//   List<Object> get props => [age!];
// }

// class PhotoChanged extends ProfileEvent {
//   final File? photo;

//   const PhotoChanged(this.photo);
//   @override
//   List<Object> get props => [photo!];
// }

// class GenderChanged extends ProfileEvent {
//   final String? gender;

//   const GenderChanged(this.gender);

//   @override
//   List<Object> get props => [gender!];
// }

// class InterestedInChanged extends ProfileEvent {
//   final String? interestedGender;

//   const InterestedInChanged(this.interestedGender);

//   @override
//   List<Object> get props => [interestedGender!];
// }

// class LocationChanged extends ProfileEvent {
//   final GeoPoint? location;

//   const LocationChanged(this.location);

//   @override
//   List<Object> get props => [location!];
// }

class Submitted extends ProfileEvent {
  final String? name, gender;
  final GeoPoint? location;
  final File? photo;
  final int? age;
  final DateTime? createdNow;

  const Submitted(
      {required this.age,
      required this.name,
      required this.createdNow, 
      required this.gender,
      required this.location,
      required this.photo});

  @override
  List<Object> get props => [name!, gender!, location!, photo!];
}
class FetchDataEvent extends ProfileEvent {}

class UpdateDataEvent extends ProfileEvent {
  final String newData;

  UpdateDataEvent(this.newData);

  @override
  List<Object> get props => [newData];
}

class EnableDisableEvent extends ProfileEvent {
  final bool isEnabled;

  EnableDisableEvent(this.isEnabled);

  @override
  List<Object> get props => [isEnabled];
}
