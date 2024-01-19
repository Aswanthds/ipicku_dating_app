import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ipicku_dating_app/data/model/user.dart';
import 'package:ipicku_dating_app/data/repositories/user_repositories.dart';

part 'firebase_data_event.dart';
part 'firebase_data_state.dart';

class FirebaseDataBloc extends Bloc<FirebaseDataEvent, FirebaseDataState> {
  final UserRepository userRepository;
  FirebaseDataBloc(this.userRepository) : super(FirebaseDataInitial()) {
    on<FirebaseDataLoadedEvent>((event, emit) async {
      emit(FirebaseDataLoading());
      await Future.delayed(const Duration(seconds: 5));
      try {
        final data = await userRepository.getUserData();

        emit(FirebaseDataLoaded(data: data));
      } catch (error) {
        emit(FirebaseDataFailure(messge: error.toString()));
      }
    });

    on<UpdateUserFieldEvent>((event, emit) async {
      emit(FirebaseDataLoading());
      try {
        final user = await userRepository.getUser();

        final docRef = FirebaseFirestore.instance.collection('users').doc(user);
        await docRef.update({event.fieldName: event.newValue});
        final data = await userRepository.getUserData();
        emit(FirebaseDataLoaded(data: data)); // Refresh data
      } catch (error) {
        emit(FirebaseDataFailure(messge: error.toString()));
      }
    });

    on<AddImagesEvent>(
      (event, emit) async {
        try {
          final user = await userRepository.getUser();

          final docRef =
              FirebaseFirestore.instance.collection('users').doc(user);
          await docRef
              .update({'images': FieldValue.arrayUnion(event.imageUrls)});
          final data = await userRepository.getUserData();
          emit(FirebaseDataLoaded(data: data)); // Refresh data
        } catch (error) {
          emit(FirebaseDataFailure(messge: error.toString()));
        }
      },
    );
    on<RemoveImageEvent>((event, emit) async {
      emit(FirebaseDataLoading());
      try {
        final user = await userRepository.getUser();
        final docRef = FirebaseFirestore.instance.collection('users').doc(user);

        final currentImages =
            (await docRef.get()).data()!['images'] as List<dynamic>?;

        // currentImages.removeAt(event.index);
        await docRef.update({
          'images': FieldValue.arrayRemove([currentImages?[event.index]])
        });
        await docRef.update({
          'images': FieldValue.arrayUnion([""])
        });

        // await docRef.update({'images': currentImages});
        final data = await userRepository.getUserData();
        emit(FirebaseDataLoaded(data: data));
      } catch (e) {
        emit(FirebaseDataFailure(messge: e.toString()));
      }
    });

    on<FirebaseDataPhotoChanged>(
      (event, emit) async {
        emit(FirebaseDataLoading());
        try {
          await userRepository.uploadImageToStorage(
              event.data, event.index, 'pic');
          final imageURLs = await userRepository.getImageURLsFromStorage();
          await userRepository.updateFirestoreWithImageURLs(imageURLs);
          // --- Fetch updated data ---
          final data = await userRepository.getUserData();
          emit(FirebaseDataLoaded(data: data));
        } catch (error) {
          emit(FirebaseDataFailure(messge: error.toString()));
        }
      },
    );
    on<FirebaseProfilePhotochanged>(
      (event, emit) async {
        try {
          final user = await userRepository.getUser();
          // await userRepository.uploadImageToStorage(
          //     event.image, 4, 'profile_pic');
          final userDocRef =
              FirebaseFirestore.instance.collection('users').doc(user);
          final url = await userRepository.getProfilePhotoLink(event.image);
          await userDocRef.update({
            'photoUrl': url,
          });
          final data = await userRepository.getUserData();
          emit(FirebaseDataLoaded(data: data));
        } catch (e) {
          emit(FirebaseDataFailure(messge: e.toString()));
        }
      },
    );
  }
}
