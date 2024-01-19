import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:ipicku_dating_app/data/functions/validators.dart';
import 'package:ipicku_dating_app/data/repositories/user_repositories.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final UserRepository _userRepository;

  LoginBloc({required UserRepository userRepository})
      : _userRepository = userRepository,
        super(LoginState.empty()) {
    on<EmailChanged>(_mapEmailChangedToState);
    on<PasswordChanged>(_mapPasswordChangedToState);
    on<LoginPressed>(_mapLoginButtonPressed);
    on<GoogleSignUp>(_mapGoogleSignIn);
  }

  FutureOr<void> _mapEmailChangedToState(
      EmailChanged event, Emitter<LoginState> emit) async {
    emit(state.update(isEmailValid: Validators.isValidEmail(event.email)));
  }

  FutureOr<void> _mapPasswordChangedToState(
      PasswordChanged event, Emitter<LoginState> emit) async {
    emit(state.update(
        isPasswordValid: Validators.isValidPassword(event.password)));
  }

  FutureOr<void> _mapLoginButtonPressed(
      LoginPressed event, Emitter<LoginState> emit) async {
    emit(LoginState.loading());

    try {
      await _userRepository.signInWithCredentials(event.email, event.password);
      final id = await _userRepository.getUser();
      final isFirst = await _userRepository.isFirstTime(id);
      if (isFirst) {
        emit(LoginState.profileNotSet());
      } else {
        emit(LoginState.sucess());
      }
    } catch (_) {
      emit(LoginState.failure());
    }
  }

  FutureOr<void> _mapGoogleSignIn(
      GoogleSignUp event, Emitter<LoginState> emit) async {
    try {
      await _userRepository.signInWithCredentials(
          event.account.email, event.account.id);
      final id = await _userRepository.getUser();
      final isFirst = await _userRepository.isFirstTime(id);
      if (isFirst) {
        emit(LoginState.profileNotSet());
      } else {
        emit(LoginState.sucess());
      }
    } catch (e) {
      emit(LoginState.failure());
    }
  }
}
