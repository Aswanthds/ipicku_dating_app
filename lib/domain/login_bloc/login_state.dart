part of 'login_bloc.dart';

@immutable
class LoginState extends Equatable {
  @override

  List<Object?> get props => throw UnimplementedError();
}

class LoginIntial extends LoginState {}

class LoginSucess extends LoginState {}

class LoginProfileNotSet extends LoginState{}

class LoginLoading extends LoginState {}

class LoginFailed extends LoginState {
  final String message;

  LoginFailed({required this.message});
}
