part of 'firebase_data_bloc.dart';

sealed class FirebaseDataState extends Equatable {
  const FirebaseDataState();

  @override
  List<Object> get props => [];
}

final class FirebaseDataInitial extends FirebaseDataState {}

class FirebaseDataLoaded extends FirebaseDataState {
  final UserModel? data;


  const FirebaseDataLoaded({ required this.data});

  @override
  List<Object> get props => [data!];
}

final class FirebaseDataLoading extends FirebaseDataState {}

class FirebaseDataFailure extends FirebaseDataState {
  final String messge;

  const FirebaseDataFailure({required this.messge});
}
