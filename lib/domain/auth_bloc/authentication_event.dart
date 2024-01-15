part of 'authentication_bloc.dart';

sealed class AuthenticationEvent extends Equatable {
  const AuthenticationEvent();

  @override
  List<Object> get props => [];
}
class AppStarted extends AuthenticationEvent {}

class LoggedIn extends AuthenticationEvent {}

class LoggedOut extends AuthenticationEvent {}

class ResetPasswordRequested extends AuthenticationEvent {
  final String email;

  const ResetPasswordRequested(this.email);

@override
 
  List<Object> get props =>[email];
}
