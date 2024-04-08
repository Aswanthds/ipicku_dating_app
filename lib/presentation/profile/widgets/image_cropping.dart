import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ipicku_dating_app/domain/firebase_data/firebase_data_bloc.dart';
import 'package:ipicku_dating_app/presentation/ui_utils/colors.dart';

class UploadPage extends StatelessWidget {
  final File croppedImage;

  const UploadPage({super.key, required this.croppedImage});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape:  RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
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
              style: ElevatedButton.styleFrom(
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero),
                backgroundColor: AppTheme.secondaryColor,
              ),
              onPressed: () {
                BlocProvider.of<FirebaseDataBloc>(context)
                    .add(FirebaseProfilePhotochanged(XFile(croppedImage.path)));
                Navigator.of(context).pop();
              },
              child: Text(
                "Update your profile photo ?",
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
