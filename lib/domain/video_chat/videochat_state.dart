part of 'videochat_bloc.dart';

sealed class VideochatState extends Equatable {
  const VideochatState();
  
  @override
  List<Object> get props => [];
}

final class VideochatInitial extends VideochatState {}



class GetVideoChatsLoaded extends VideochatState {
  final List<Map<String, dynamic>> userData;

  const GetVideoChatsLoaded({required this.userData});
  @override
  List<Object> get props => [userData];
}

class GetVideoChatsLoading extends VideochatState {}

class GetVideoChatsError extends VideochatState {}
