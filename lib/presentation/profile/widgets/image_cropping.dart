import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ipicku_dating_app/domain/firebase_data/firebase_data_bloc.dart';

class UploadPage extends StatelessWidget {
  final File croppedImage;

  const UploadPage({super.key, required this.croppedImage});

  // Implement your Firebase upload logic here

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.file(
              croppedImage,
              width: 200,
              height: 200,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                BlocProvider.of<FirebaseDataBloc>(context)
                    .add(FirebaseProfilePhotochanged(XFile(croppedImage.path)));
                Navigator.of(context).pop();
              },
              child: const Text("Upload to Firebase"),
            ),
          ],
        ),
      ),
    );
  }
}
