import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:ipicku_dating_app/data/functions/validators.dart';

import 'package:ipicku_dating_app/data/repositories/user_repositories.dart';
import 'package:ipicku_dating_app/domain/signup_bloc/sign_up_event.dart';
import 'package:ipicku_dating_app/domain/signup_bloc/sign_up_state.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  final UserRepository _userRepository;
  SignUpBloc(this._userRepository) : super(SignUpState.empty()) {
    on<EmailChanged>(_mapEmailChanged);
    on<PasswordChanged>(_mapPasswordChanged);
    on<SignUpPressed>(_mapSignUpPressed);
    
  }

  FutureOr<void> _mapEmailChanged(
      EmailChanged event, Emitter<SignUpState> emit) {
    emit(state.update(isEmailValid: Validators.isValidEmail(event.email)));
  }

  FutureOr<void> _mapPasswordChanged(
      PasswordChanged event, Emitter<SignUpState> emit) {
    emit(
        state.update(isEmailValid: Validators.isValidPassword(event.password)));
  }

  FutureOr<void> _mapSignUpPressed(
      SignUpPressed event, Emitter<SignUpState> emit) async {
    emit(SignUpState.loading());

    try {
      await _userRepository.signUp(
          email: event.email, password: event.password);
      emit(SignUpState.success());
    } catch (_) {
      emit(SignUpState.failure());
    }
  }
}
