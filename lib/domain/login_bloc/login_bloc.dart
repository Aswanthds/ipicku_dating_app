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
      final isProfileSet = await _userRepository.isProfileSet(id);
      await _userRepository.storeDeviceToken();
      if (!isFirst || !isProfileSet) {
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
      // Sign in with Google
      await _userRepository.signInwithGoogle();

      // Get user ID
      final userId = await _userRepository.getUser();

      // Check if it's the first time signing in
      final isFirstTime = await _userRepository.isFirstTime(userId);

      // Check if the profile is set
      final isProfileSet = await _userRepository.isProfileSet(userId);

      if (!isFirstTime || !isProfileSet) {
        // User is either not signing in for the first time or the profile is not set
        emit(LoginProfileNotSet());
      } else {
        // User is signing in for the first time and the profile is set
        emit(LoginSucess());
      }
    } catch (e) {
      emit(LoginFailed(message: e.toString()));
    }
  }
}
