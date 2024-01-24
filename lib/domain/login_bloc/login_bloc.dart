import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:ipicku_dating_app/data/repositories/user_repositories.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final UserRepository _userRepository;

  LoginBloc({required UserRepository userRepository})
      : _userRepository = userRepository,
        super(LoginIntial()) {

    on<LoginPressed>(_mapLoginButtonPressed);
    on<GoogleSignUp>(_mapGoogleSignIn);
  }
  FutureOr<void> _mapLoginButtonPressed(
      LoginPressed event, Emitter<LoginState> emit) async {
    emit(LoginLoading());

    try {
      await _userRepository.signInWithCredentials(event.email, event.password);
      final id = await _userRepository.getUser();
      final isFirst = await _userRepository.isFirstTime(id);
      if (isFirst) {
        emit(LoginProfileNotSet());
      } else {
        emit(LoginSucess());
      }
    } catch (_) {
      emit(LoginFailed(message: "Failed"));
    }
  }

  FutureOr<void> _mapGoogleSignIn(
      GoogleSignUp event, Emitter<LoginState> emit) async {
    try {
      await _userRepository.signInwithGoogle();
      final id = await _userRepository.getUser();
      final isFirst = await _userRepository.isFirstTime(id);
      if (isFirst) {
        emit(LoginProfileNotSet());
      } else {
        emit(LoginSucess());
      }
    } catch (e) {
      emit(LoginFailed(message: e.toString()));
    }
  }
}

  

