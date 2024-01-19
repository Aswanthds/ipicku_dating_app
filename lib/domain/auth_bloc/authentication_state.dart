part of 'authentication_bloc.dart';

sealed class AuthenticationState extends Equatable {
  const AuthenticationState();

  @override
  List<Object> get props => [];
}

class IntialAuthenticationState extends AuthenticationState {}

class AuthenticationSuccess extends AuthenticationState {
  final String userId;

  const AuthenticationSuccess(this.userId);

  @override
  List<Object> get props => [userId];

  @override
  String toString() => "Authenticated $userId";
}

class AuthenticationSucessButNotSet extends AuthenticationState {
  final String userId;

  const AuthenticationSucessButNotSet(this.userId);

  @override
  List<Object> get props => [userId];
}

class AuthenticationFailureState extends AuthenticationState {
  final String errorMessage;

  const AuthenticationFailureState(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];
}

class AuthenticationLoading extends AuthenticationState {
  final bool isLoading;

  const AuthenticationLoading(this.isLoading);

  @override
  List<Object> get props => [isLoading];
}

class Unauthenticated extends AuthenticationState {}

class ResetPasswordInProgress extends AuthenticationState {}

class ResetPasswordSuccess extends AuthenticationState {}

class ResetPasswordFailure extends AuthenticationState {
  final String message;

  const ResetPasswordFailure(this.message);
}

class AccountDeleteReq extends AuthenticationState {}

class AccountDeletedState extends AuthenticationState {}

class AccountDeletingState extends AuthenticationState {}

class AccountDeletingFailed extends AuthenticationState {
  final String message;

  const AccountDeletingFailed(this.message);
}
