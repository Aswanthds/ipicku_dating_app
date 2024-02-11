part of 'videochat_bloc.dart';

sealed class VideochatEvent extends Equatable {
  const VideochatEvent();

  @override
  List<Object> get props => [];
}
class GetVideoChatsList extends VideochatEvent {
}
class SendVideoChatData extends VideochatEvent {
  final String token, selectedUser;

  const SendVideoChatData({required this.token, required this.selectedUser});
}
