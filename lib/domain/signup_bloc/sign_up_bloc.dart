import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

import 'package:ipicku_dating_app/data/repositories/user_repositories.dart';
import 'package:ipicku_dating_app/domain/signup_bloc/sign_up_event.dart';
import 'package:ipicku_dating_app/domain/signup_bloc/sign_up_state.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  final UserRepository _userRepository;
  SignUpBloc(this._userRepository) : super(SignupIntial()) {
    on<SignUpPressed>(_mapSignUpPressed);
    on<GoogleSignUpEvent>(_mapGoogelSignUp);
  }

  FutureOr<void> _mapSignUpPressed(
      SignUpPressed event, Emitter<SignUpState> emit) async {
    emit(SignUpLoading());

    try {
      await _userRepository.signUp(
          email: event.email, password: event.password);
      emit(SignUpSucess());
    } catch (_) {
      emit(SignUpFailed(message: 'SignIn Failed'));
    }
  }

  FutureOr<void> _mapGoogelSignUp(
      GoogleSignUpEvent event, Emitter<SignUpState> emit) async {
    try {
      final account = await _userRepository.googleSignUp();
      final user = account?.user;
      if (user != null) {
        // Check if the user is new
        if (account?.additionalUserInfo?.isNewUser ?? false) {
          emit(SignUpSucess());
          debugPrint('New user signed in: ${user.displayName}');
        } else {
          emit(SignUpFailed(message: 'SignIn Failed'));
          debugPrint('Existing user signed in: ${user.displayName}');
        }
      } else {
        emit(SignUpFailed(message: 'SignIn Failed'));
        debugPrint('Sign-in failed.');
      }
    } catch (e) {
      emit(SignUpFailed(message: 'SignUp Failed'));
    }
  }
}
