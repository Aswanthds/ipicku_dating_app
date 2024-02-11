part of 'messaging_bloc.dart';

sealed class MessagingEvent extends Equatable {
  const MessagingEvent();

  @override
  List<Object> get props => [];
}

class SendMessageEvent extends MessagingEvent {
  final String? contnet;
  final String recieverId;
  final XFile? imagel;

  const SendMessageEvent({
    required this.recieverId,
    this.contnet,
    this.imagel,
  });
}

class GetMessages extends MessagingEvent {
  final String? userId, recieverId;

  const GetMessages({required this.userId, required this.recieverId});
}

class DeleteMessage extends MessagingEvent {
  final String userId, recieverId, msgId;

  const DeleteMessage({required this.userId, required this.recieverId, required this.msgId});
}
class GetLastMessage extends MessagingEvent {
  final String recieverId;

  const GetLastMessage({required this.recieverId});
}
