part of 'notifications_bloc.dart';

sealed class NotificationsEvent extends Equatable {
  const NotificationsEvent();

  @override
  List<Object> get props => [];
}

class NotificationReceivedEvent extends NotificationsEvent {
  final String title, body, userId;
  final NotificationType type;

  const NotificationReceivedEvent(
      this.title, this.body, this.userId, this.type);
}

class GetNotifications extends NotificationsEvent {}

class MuteUser extends NotificationsEvent {
  final String userId;

  const MuteUser({required this.userId});
}

class BlocUser extends NotificationsEvent {
  final String userId;

  const BlocUser({required this.userId});
}
