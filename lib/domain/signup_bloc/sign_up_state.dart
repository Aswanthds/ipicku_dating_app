import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
class SignUpState  extends Equatable {
  @override
  List<Object?> get props => throw UnimplementedError();
}

 class SignUpSucess extends SignUpState{}
 class SignupIntial extends SignUpState {}

class SignUpLoading extends SignUpState {}

class SignUpFailed extends SignUpState {
  final String message;

  SignUpFailed({required this.message});
}
