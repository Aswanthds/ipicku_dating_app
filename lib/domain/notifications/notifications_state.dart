part of 'notifications_bloc.dart';

sealed class NotificationsState extends Equatable {
  const NotificationsState();

  @override
  List<Object> get props => [];
}

final class NotificationsInitial extends NotificationsState {}

class GetNotificationsLoaded extends NotificationsState {
  final Stream<QuerySnapshot<Map<String, dynamic>>> data;

  const GetNotificationsLoaded({required this.data});
}

class GetNotificationsError extends NotificationsState {}

class GetNotificationsLoading extends NotificationsState {}

//

// class MuteMessagesLoading extends NotificationsState {}

// class MuteMessagesDone extends NotificationsState {
//   final bool value;

//   const MuteMessagesDone({required this.value});
// }

// class MuteMessagesError extends NotificationsState {}

// class BlocUserReq extends NotificationsState {}

// class BlocUserDone extends NotificationsState {
//   final Map<String, dynamic> value;

//   const BlocUserDone({required this.value});
// }

// class BlocUserErro extends NotificationsState {}

class GetNotificationPrefsState extends NotificationsState {
  final Map<String, dynamic> data;

  const GetNotificationPrefsState({required this.data});
}

class GetNotificationPrefsStateLoading extends NotificationsState {}
