part of 'matches_data_bloc.dart';

sealed class MatchesDataState extends Equatable {
  const MatchesDataState();
  
  @override
  List<Object> get props => [];
}

final class MatchesDataInitial extends MatchesDataState {}

class MatchesListLoading extends MatchesDataState {}

class MatchesListLoaded extends MatchesDataState {
  final List<Map<String, dynamic>> userProfile;

  const MatchesListLoaded({required this.userProfile});
}

class MatchesListLoadError extends MatchesDataState {
  final String errorMessage;

  const MatchesListLoadError({required this.errorMessage});
}

class SelectedListLoading extends MatchesDataState {}

class SelectedListLoaded extends MatchesDataState {
  final List<Map<String, dynamic>> userProfile;

  const SelectedListLoaded({required this.userProfile});
}

class SelectedListLoadError extends MatchesDataState {
  final String errorMessage;

  const SelectedListLoadError({required this.errorMessage});
}

class DatePickedState extends MatchesDataState {}

class DatePickedLoadingState extends MatchesDataState {}

class DatePickedErrorState extends MatchesDataState {
  final String errorMessage;

  const DatePickedErrorState(this.errorMessage);
}


class MutualListLoading extends MatchesDataState {}

class MutualListLoaded extends MatchesDataState {
  final List<Map<String, dynamic>> userProfile;

  const MutualListLoaded({required this.userProfile});
}

class MutualListLoadError extends MatchesDataState {
  final String errorMessage;

  const MutualListLoadError({required this.errorMessage});
}
