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

class MuteMessagesIntiated extends NotificationsState {}

class MuteMessagesDone extends NotificationsState {}

class MuteMessagesError extends NotificationsState {}

class BlocUserReq extends NotificationsState {}

class BlocUserDone extends NotificationsState {}

class BlocUserErro extends NotificationsState {}
