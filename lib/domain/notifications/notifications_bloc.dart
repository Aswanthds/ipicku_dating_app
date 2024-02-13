import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:ipicku_dating_app/data/repositories/local.dart';
import 'package:ipicku_dating_app/data/repositories/user_repositories.dart';

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
    
    on<UpdateNotificationPreferences>(
      (event, emit) async {
        emit(GetNotificationPrefsStateLoading());
        await UserRepository()
            .updateNotificationPreferences(event.fieldName, event.newValue);
        final data = await UserRepository().getNotificationsValue();
        emit(GetNotificationPrefsState(data: data));
      },
    );
    on<GetNotificationPreferences>(
      (event, emit) async {
        emit(GetNotificationPrefsStateLoading());
        final data = await UserRepository().getNotificationsValue();
        emit(GetNotificationPrefsState(data: data));
      },
    );
  }
}
