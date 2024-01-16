import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:ipicku_dating_app/data/model/user.dart';
import 'package:ipicku_dating_app/data/repositories/firebas_actions.dart';

part 'firebase_data_event.dart';
part 'firebase_data_state.dart';

class FirebaseDataBloc extends Bloc<FirebaseDataEvent, FirebaseDataState> {
  final FirebaseRepository _userRepository;
  FirebaseDataBloc(this._userRepository) : super(FirebaseDataInitial()) {
    on<FirebaseDataFetch>(getFirebaseData);
  }

  FutureOr<void> getFirebaseData(
      FirebaseDataFetch event, Emitter<FirebaseDataState> emit) async {
    try {
      final  users = await _userRepository.getData();
      emit(FirebaseDataLoaded(users: users!));
    } catch (e) {
      debugPrint("Error $e");
    }
  }
}
