import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:ipicku_dating_app/data/repositories/messaging_repository.dart';

part 'messages_event.dart';
part 'messages_state.dart';

class MessagesBloc extends Bloc<MessagesEvent, MessagesState> {
  MessagesBloc() : super(MessagesInitial()) {
    on<GetChatList>((event, emit) async {
      emit(GetChatsLoading());
      try {
        final data = await MessagingRepository.getUserChatList();
        //debugPrint(data.toString());

        emit(GetChatsLoaded(userData: data));
      } catch (e) {
        debugPrint("Error occured wihle chatlist $e");
        emit(GetChatsError());
      }
    });
    on<DeleteUserChat>(
      (event, emit) async {
        emit(GetChatsLoading());
        try {
          await MessagingRepository.deleteUserChat(event.recieverId);
          final data = await MessagingRepository.getUserChatList();

          emit(GetChatsLoaded(userData: data));
        } catch (e) {
          debugPrint("Error occured wihle chatlist $e");
          emit(GetChatsError());
        }
      },
    );
    
  }
}
