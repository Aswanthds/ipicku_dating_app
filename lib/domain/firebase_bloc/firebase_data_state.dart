part of 'firebase_data_bloc.dart';

sealed class FirebaseDataState extends Equatable {
  const FirebaseDataState();
  
  @override
  List<Object> get props => [];
}

class FirebaseDataInitial extends FirebaseDataState {}

class FirebaseDataLoading extends FirebaseDataState {}

class FirebaseDataLoaded extends FirebaseDataState {
  final UserModel users;

  const FirebaseDataLoaded({required this.users});

  @override
  List<Object> get props => [users];
}

class FirebaseDataError extends FirebaseDataState {
  final String message;

  const FirebaseDataError({required this.message});

  @override
  List<Object> get props => [message];
}
