part of 'login_bloc.dart';

@immutable
class LoginState {
  final bool isEmailValid;
  final bool isPasswordValid;
  final bool isSubmitting;
  final bool isSuccess;
  final bool isFailure;
  final bool isProfileDone;

  const LoginState({
    required this.isEmailValid,
    required this.isPasswordValid,
    required this.isSubmitting,
    required this.isSuccess,
    required this.isFailure,
    required this.isProfileDone,
  });

  bool get isFormValid => isEmailValid && isPasswordValid;

  factory LoginState.empty() {
    return const LoginState(
        isEmailValid: true,
        isPasswordValid: true,
        isSubmitting: false,
        isSuccess: false,
        isFailure: false,
        isProfileDone: false);
  }
  factory LoginState.loading() {
    return const LoginState(
        isEmailValid: true,
        isPasswordValid: true,
        isSubmitting: true,
        isSuccess: false,
        isProfileDone: false,
        isFailure: false);
  }
  factory LoginState.profileNotSet() {
    return const LoginState(
        isEmailValid: true,
        isProfileDone: false,
        isPasswordValid: true,
        isSubmitting: false,
        isSuccess: true,
        isFailure: false);
  }
  factory LoginState.failure() {
    return const LoginState(
        isEmailValid: true,
        isPasswordValid: true,
        isSubmitting: false,
        isSuccess: false,
        isFailure: true,
        isProfileDone: false);
  }
  factory LoginState.sucess() {
    return const LoginState(
        isEmailValid: true,
        isPasswordValid: true,
        isSubmitting: false,
        isProfileDone: true,
        isSuccess: true,
        isFailure: false);
  }
  LoginState copyWith({
    bool? isEmailValid,
    bool? isPasswordValid,
    bool? isSubmitting,
    bool? isSuccess,
    bool? isFailure,
    bool? isProfileDone,
  }) {
    return LoginState(
      isEmailValid: isEmailValid ?? this.isEmailValid,
      isPasswordValid: isPasswordValid ?? this.isPasswordValid,
      isSubmitting: isSubmitting ?? this.isPasswordValid,
      isSuccess: isSuccess ?? this.isSuccess,
      isFailure: isFailure ?? this.isFailure,
      isProfileDone: isProfileDone ?? this.isProfileDone,
    );
  }

  LoginState update({bool? isEmailValid, bool? isPasswordValid}) {
    return copyWith(
      isEmailValid: isEmailValid,
      isPasswordValid: isPasswordValid,
      isFailure: false,
      isSubmitting: false,
      isSuccess: false,
      isProfileDone: true,
    );
  }
}
