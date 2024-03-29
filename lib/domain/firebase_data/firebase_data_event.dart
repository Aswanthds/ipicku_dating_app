part of 'firebase_data_bloc.dart';

sealed class FirebaseDataEvent extends Equatable {
  const FirebaseDataEvent();

  @override
  List<Object> get props => [];
}

class FirebaseDataInitialEvent extends FirebaseDataEvent {}

class FirebaseDataLoadedEvent extends FirebaseDataEvent {}

class UpdateUserFieldEvent extends FirebaseDataEvent {
  final String fieldName;
  final dynamic newValue;

  const UpdateUserFieldEvent(this.fieldName, this.newValue);
}

class AddImagesEvent extends FirebaseDataEvent {
  final List<String> imageUrls;

  const AddImagesEvent(this.imageUrls);
}

class RemoveImageEvent extends FirebaseDataEvent {
  final int index;

  const RemoveImageEvent(this.index);
}

class FirebaseDataPhotoChanged extends FirebaseDataEvent {
  final XFile data;
  final int index;

  const FirebaseDataPhotoChanged(this.data, this.index);
}

class FirebaseProfilePhotochanged extends FirebaseDataEvent {
  final XFile image;

  const FirebaseProfilePhotochanged(this.image);
}

class FirebaseAddData extends FirebaseDataEvent {
  final String field;
  final List<dynamic> value;

  const FirebaseAddData(this.field, this.value);
}

class AddUseFieldData extends FirebaseDataEvent {
  final String fieldName;
  final dynamic newValue;

  const AddUseFieldData({required this.fieldName, required this.newValue});
  @override
  
  List<Object> get props => [fieldName, newValue];
}
