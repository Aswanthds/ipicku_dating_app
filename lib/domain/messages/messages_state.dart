part of 'messages_bloc.dart';

sealed class MessagesState extends Equatable {
  const MessagesState();

  @override
  List<Object> get props => [];
}

final class MessagesInitial extends MessagesState {}

class GetChatsLoaded extends MessagesState {
  final List<Map<String, dynamic>> userData;

  const GetChatsLoaded({required this.userData});
  @override
  List<Object> get props => [userData];
}

class GetChatsLoading extends MessagesState {}

class GetChatsError extends MessagesState {}

//

