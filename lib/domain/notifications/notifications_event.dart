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

// class MuteUser extends NotificationsEvent {
//   final String userId;
//   final bool value;
//   const MuteUser({
//     required this.userId,
//     required this.value,
//   });
// }

// class BlocUser extends NotificationsEvent {
//   final String userId;
//   final bool value;
//   const BlocUser({
//     required this.userId,
//     required this.value,
//   });
// }

class GetNotificationPreferences extends NotificationsEvent {}

class UpdateNotificationPreferences extends NotificationsEvent {
  final String fieldName;
  final bool newValue;

 const UpdateNotificationPreferences({required this.fieldName, required this.newValue});
}
