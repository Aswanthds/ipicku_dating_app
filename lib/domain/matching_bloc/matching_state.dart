part of 'matching_bloc.dart';

sealed class MatchingState extends Equatable {
  const MatchingState();

  @override
  List<Object> get props => [];
}

class MatchesIntialState extends MatchingState {}

class RandomProfileLoaded extends MatchingState {
  final List<Map<String, dynamic>> userProfile;

  const RandomProfileLoaded(this.userProfile);
}

class RandomProfileError extends MatchingState {
  final String errorMessage;

  const RandomProfileError(this.errorMessage);
}

class RandomProfileLoading extends MatchingState {}

class Regionprofiles extends MatchingState {
  final List<Map<String, dynamic>> locationUsers;
  final List<Map<String, dynamic>> interest;
  const Regionprofiles({required this.locationUsers, required this.interest});
}

class RegionprofilesError extends MatchingState {
  final String errorMessage;

  const RegionprofilesError(this.errorMessage);
}
class RegionprofilesLoading extends MatchingState{}