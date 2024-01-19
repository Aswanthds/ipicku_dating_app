part of 'login_bloc.dart';

sealed class LoginEvent extends Equatable {
  const LoginEvent();

  @override
  List<Object> get props => [];
}

class EmailChanged extends LoginEvent {
  final String email;

  const EmailChanged({required this.email});

  @override
  List<Object> get props => [email];

  @override
  String toString() => "Email $email";
}

class PasswordChanged extends LoginEvent {
  final String password;

  const PasswordChanged({required this.password});

  @override
  List<Object> get props => [password];

  @override
  String toString() => "Password $password";
}

class Submitted extends LoginEvent {
  final String email, password;

  const Submitted({required this.email, required this.password});
  @override
  List<Object> get props => [password, email];
}

class LoginPressed extends LoginEvent {
  final String email, password;

  const LoginPressed({required this.email, required this.password});
  @override
  List<Object> get props => [password, email];
}


class GoogleSignUp extends LoginEvent {
  final GoogleSignInAccount account;

  const GoogleSignUp({required this.account});
}
