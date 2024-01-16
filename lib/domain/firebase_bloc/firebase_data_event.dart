part of 'firebase_data_bloc.dart';

sealed class FirebaseDataEvent extends Equatable {
  const FirebaseDataEvent();

  @override
  List<Object> get props => [];
}

class FirebaseDataFetch extends FirebaseDataEvent{
  
}
