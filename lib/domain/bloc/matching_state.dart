part of 'matching_bloc.dart';

sealed class MatchingState extends Equatable {
  const MatchingState();

  @override
  List<Object> get props => [];
}

class MatchesIntialState extends MatchingState {}

class MatchesLoadingState extends MatchingState {}

class MatchesLoadedState extends MatchingState {
  final Stream<QuerySnapshot> matchedList;
  final Stream<QuerySnapshot> selectedList;

  const MatchesLoadedState(this.matchedList, this.selectedList);
  @override
  List<Object> get props => [matchedList, selectedList];
}

class MatchesLoadedFailed extends MatchingState {
  final String message;

  const MatchesLoadedFailed(this.message);
}

//**** */
class RandomProfileLoaded extends MatchingState {
  final List<Map<String, dynamic>> userProfile;

  const RandomProfileLoaded(this.userProfile);
}

class RandomProfileError extends MatchingState {
  final String errorMessage;

  const RandomProfileError(this.errorMessage);
}
class RandomProfileLoading extends MatchingState{}


class Regionprofiles extends  MatchingState{
  final List<Map<String, dynamic>> userProfile;

  const Regionprofiles({required this.userProfile});
}

class RegionprofilesError extends MatchingState {
  final String errorMessage;

  const RegionprofilesError(this.errorMessage);
}
