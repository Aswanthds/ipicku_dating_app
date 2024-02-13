part of 'messages_bloc.dart';

sealed class MessagesEvent extends Equatable {
  const MessagesEvent();

  @override
  List<Object> get props => [];
}

class GetChatList extends MessagesEvent {}

class DeleteUserChat extends MessagesEvent {
  final String recieverId;

  const DeleteUserChat({required this.recieverId});
}

//mute && block

class MuteUser extends MessagesEvent {
  final String userId;
  final bool value;
  const MuteUser({
    required this.userId,
    required this.value,
  });
}

class BlocUser extends MessagesEvent {
  final String userId;
  final bool value;
  const BlocUser({
    required this.userId,
    required this.value,
  });
}


