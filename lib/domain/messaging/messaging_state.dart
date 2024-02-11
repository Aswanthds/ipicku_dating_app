part of 'messaging_bloc.dart';

sealed class MessagingState extends Equatable {
  const MessagingState();

  @override
  List<Object> get props => [];
}

final class MessagingInitial extends MessagingState {}

class MessageStreamLoaded extends MessagingState {
  final Stream<QuerySnapshot> messages;

  const MessageStreamLoaded({required this.messages});
}

class MessageStreamError extends MessagingState {
  final String error;

  const MessageStreamError({required this.error});
}


class MessageStreamLaoding extends MessagingState {

}
class GetLastMessageLoaded extends MessagingState {
  final QueryDocumentSnapshot<Map<String, dynamic>> message;

  const GetLastMessageLoaded({required this.message});
}

class GetLastMessageLoading extends MessagingState {}
