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


