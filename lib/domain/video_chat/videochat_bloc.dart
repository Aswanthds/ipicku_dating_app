import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:ipicku_dating_app/data/repositories/vc_repository.dart';

part 'videochat_event.dart';
part 'videochat_state.dart';

class VideochatBloc extends Bloc<VideochatEvent, VideochatState> {
  VideochatBloc() : super(VideochatInitial()) {
    on<GetVideoChatsList>(
      (event, emit) async {
        emit(GetVideoChatsLoading());
        try {
          final data = await VideoRepository.getVideoCallDetails();
          debugPrint(data.toString());

          emit(GetVideoChatsLoaded(userData: data));
        } catch (e) {
          debugPrint("Error occured wihle chatlist $e");
          emit(GetVideoChatsError());
        }
      },
    );
     on<SendVideoChatData>(
      (event, emit) async {
        try {
          VideoRepository.storeVideoDetails(event.selectedUser, event.token);
        } catch (e) {
          debugPrint(e.toString());
        }
      },
    );
  }
}
