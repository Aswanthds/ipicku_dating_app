import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';

@immutable
abstract class SignUpEvent extends Equatable {
  const SignUpEvent();

  @override
  List<Object> get props => [];
}

class EmailChanged extends SignUpEvent {
  final String email;

  const EmailChanged({required this.email});

  @override
  List<Object> get props => [email];

  @override
  String toString() => 'EmailChanged {email: $email}';
}

class PasswordChanged extends SignUpEvent {
  final String password;

  const PasswordChanged({required this.password});

  @override
  List<Object> get props => [password];

  @override
  String toString() => 'PasswordChanged {password: $password}';
}



class SignUpPressed extends SignUpEvent {
  final String email;
  final String password;

  const SignUpPressed({required this.email, required this.password});

  @override
  List<Object> get props => [email, password];
}

class GoogleSignUpEvent extends SignUpEvent {
  final GoogleSignInAccount account;

  const GoogleSignUpEvent({required this.account});

}
