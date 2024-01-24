part of 'matching_bloc.dart';

sealed class MatchingEvent extends Equatable {
  const MatchingEvent();

  @override
  List<Object> get props => [];
}

class LoadListsEvent extends MatchingEvent {
  final String userId;

  const LoadListsEvent({required this.userId});

  @override
  List<Object> get props => [userId];
}

class AcceptUserEvent extends MatchingEvent {
  final String currentUser, selectedUser;

  const AcceptUserEvent({
    required this.currentUser,
    required this.selectedUser,
  });

  @override
  List<Object> get props => [
        currentUser,
        selectedUser,
      ];
}

class DeleteUserEvent extends MatchingEvent {
  final String currentUser, selectedUser;

  const DeleteUserEvent(
      {required this.currentUser, required this.selectedUser});

  @override
  List<Object> get props => [
        currentUser,
        selectedUser,
      ];
}

class ProfileSelectedState extends MatchingEvent {
  final String selectedUser;

  const ProfileSelectedState({required this.selectedUser});
}

class GetRandomUsers extends MatchingEvent {}

class GetRegionUsers extends MatchingEvent {
  final double radius;

  const GetRegionUsers({required this.radius});
}
