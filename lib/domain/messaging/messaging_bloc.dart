import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ipicku_dating_app/data/repositories/messaging_repository.dart';

part 'messaging_event.dart';
part 'messaging_state.dart';

class MessagingBloc extends Bloc<MessagingEvent, MessagingState> {
  MessagingBloc() : super(MessagingInitial()) {
    on<SendMessageEvent>((event, emit) async {
      try {
        await MessagingRepository.sendMessage(
            recieverId: event.recieverId,
            content: event.contnet,
            image: event.imagel);
      } catch (e) {
        debugPrint(e.toString());
      }
    });
    on<GetMessages>((event, emit) async {
      emit(MessageStreamLaoding());
      try {
        final Stream<QuerySnapshot> data =
            MessagingRepository.getMessages(event.userId, event.recieverId);
        debugPrint(data.toString());

        emit(MessageStreamLoaded(messages: data));
      } catch (e) {
        debugPrint("Error occured wihle chatlist $e");
        emit(MessageStreamError(error: e.toString()));
      }
    });
    on<DeleteMessage>(
      (event, emit) async {
        emit(MessageStreamLaoding());
        try {
          var list = [event.userId, event.recieverId];
          list.sort();
          await MessagingRepository.deleteMessage(list.join('_'), event.msgId);
          final Stream<QuerySnapshot> data =
              MessagingRepository.getMessages(event.userId, event.recieverId);
          emit(MessageStreamLoaded(messages: data));
        } catch (e) {
          debugPrint("Error occured wihle chatlist $e");
          emit(MessageStreamError(error: e.toString()));
        }
      },
    );
    on<GetLastMessage>(
      (event, emit) async {
        emit(GetLastMessageLoading());
        try {
          final data =
              await MessagingRepository.getLastMessage(event.recieverId);
          debugPrint(data.toString());
          emit(GetLastMessageLoaded(message: data));
        } catch (e) {
          debugPrint("error $e");
        }
      },
    );
  }
}
