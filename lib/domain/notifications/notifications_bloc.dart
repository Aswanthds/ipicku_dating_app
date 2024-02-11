
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:ipicku_dating_app/data/repositories/local.dart';
import 'package:ipicku_dating_app/data/repositories/messaging_repository.dart';

part 'notifications_event.dart';
part 'notifications_state.dart';

class NotificationsBloc extends Bloc<NotificationsEvent, NotificationsState> {
  NotificationsBloc() : super(NotificationsInitial()) {
    on<NotificationReceivedEvent>((event, emit) async {
      try {
        await InAppNotificatioons().storeNotifications(
            event.userId, event.title, event.body, event.type);
      } catch (e) {
        debugPrint(e.toString());
      }
    });
    on<GetNotifications>(
      (event, emit) async {
        emit(GetNotificationsLoading());
        try {
          final data = await InAppNotificatioons().getNotifications();
          emit(GetNotificationsLoaded(data: data));
        } catch (e) {
          debugPrint("Error $e");
          emit(GetNotificationsError());
        }
      },
    );
    on<MuteUser>(
      (event, emit) async {
        emit(MuteMessagesIntiated());
        try {
          await MessagingRepository().addToMutedList(event.userId);
          emit(MuteMessagesDone());
        } catch (e) {
          debugPrint(e.toString());
          emit(MuteMessagesError());
        }
      },
    );
    on<BlocUser>(
      (event, emit) async{
         emit(BlocUserReq());
        try {
          await MessagingRepository().addToBlockedList(event.userId);
          emit(BlocUserDone());
        } catch (e) {
          debugPrint(e.toString());
          emit(BlocUserErro());
        }
      },
    );
  }
}
