import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:ipicku_dating_app/data/repositories/user_repositories.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final UserRepository userRepository;

  AuthenticationBloc({required this.userRepository})
      : super(IntialAuthenticationState()) {
    on<AppStarted>(_mapAppStartedToState);
    on<LoggedIn>(_mapLoggedInState);
    on<LoggedOut>(_mapLoggedOutToState);
    on<ResetPasswordRequested>(_mapResetpassword);
    on<DeleteAccount>(_mapDeleteAccount);
  }

  Future<void> _mapAppStartedToState(
      AppStarted event, Emitter<AuthenticationState> emit) async {
    try {
      final isSigned = await userRepository.isSignedIn();
      if (isSigned) {
        final userId = await userRepository.getUser();
        final isFirst = await userRepository.isFirstTime(userId);

        if (!isFirst) {
          emit(AuthenticationSucessButNotSet(userId));
        } else {
          emit(AuthenticationSuccess(userId));
        }
      } else {
        emit(Unauthenticated());
      }
    } catch (e) {
      emit(Unauthenticated());
    }
  }

  Future<void> _mapLoggedInState(
      LoggedIn event, Emitter<AuthenticationState> emit) async {
    final isFirstTime =
        await userRepository.isFirstTime(await userRepository.getUser());

    if (!isFirstTime) {
      emit(AuthenticationSucessButNotSet(await userRepository.getUser()));
    } else {
      emit(AuthenticationSuccess(await userRepository.getUser()));
    }
  }

  Future<void> _mapLoggedOutToState(
      LoggedOut event, Emitter<AuthenticationState> emit) async {
    await userRepository.signOut();
    emit(Unauthenticated());
  }

  FutureOr<void> _mapResetpassword(
      ResetPasswordRequested event, Emitter<AuthenticationState> emit) async {
    emit(ResetPasswordInProgress());
    try {
      final user = await userRepository.sendPasswordResetEmail(event.email);

      if (user) {
        emit(ResetPasswordSuccess());
      } else {
        emit(const ResetPasswordFailure("Error occured"));
      }
    } catch (error) {
      debugPrint("error $error");
      emit(const ResetPasswordFailure('User not registered'));
    }
  }

  FutureOr<void> _mapDeleteAccount(
      DeleteAccount event, Emitter<AuthenticationState> emit) async {
    emit(AccountDeletingState());
    try {
      await userRepository.deleteAccount();
      await userRepository.deleteUserAccount();
      emit(AccountDeletedState());
      emit(Unauthenticated());
    } catch (e) {
      emit(AccountDeletingFailed(e.toString()));
    }
  }
}
