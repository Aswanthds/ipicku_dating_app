part of 'matches_data_bloc.dart';

sealed class MatchesDataEvent extends Equatable {
  const MatchesDataEvent();

  @override
  List<Object> get props => [];
}

class MatchesLoadingEvent extends MatchesDataEvent {}

class SelectedListLoadingEvent extends MatchesDataEvent {}

class MutualListLoadingEvent extends MatchesDataEvent {}
class AddUserAsAPick extends MatchesDataEvent {
  final String selectedUserId;

  const AddUserAsAPick({required this.selectedUserId});
}
class RemoveUserFromPick extends MatchesDataEvent {
  final String selectedUserId;

  const RemoveUserFromPick({required this.selectedUserId});
}
