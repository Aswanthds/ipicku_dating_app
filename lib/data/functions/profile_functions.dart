import 'dart:io';
import 'package:geocoding/geocoding.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ipicku_dating_app/constants.dart';
import 'package:ipicku_dating_app/domain/firebase_data/firebase_data_bloc.dart';
import 'package:ipicku_dating_app/presentation/profile/widgets/image_cropping.dart';

class ProfileFunctions {
  static int calculateAge(DateTime? selectedDate) {
    if (selectedDate != null) {
      final today = DateTime.now();
      var age = today.year - selectedDate.year;
      final monthDiff = today.month - selectedDate.month;

      if (monthDiff < 0 || (monthDiff == 0 && today.day < selectedDate.day)) {
        age--;
      }
      return age;
    }
    return 0;
  }

  static Future<GeoPoint> getLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    return GeoPoint(position.latitude, position.longitude);
  }

  static Future<XFile?> pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedImage =
        await picker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      return pickedImage;
    }
    debugPrint(pickedImage!.path);
    return null;
  }

  static Future<File?> cropImage(File image) async {
    final croppedFile = await ImageCropper().cropImage(
        sourcePath: image.path,
        aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
        compressQuality: 100,
        maxHeight: 1000,
        maxWidth: 1000,
        compressFormat: ImageCompressFormat.jpg,
        aspectRatioPresets: [
          CropAspectRatioPreset.square,
          CropAspectRatioPreset.ratio3x2,
          CropAspectRatioPreset.original,
          CropAspectRatioPreset.ratio4x3,
          CropAspectRatioPreset.ratio16x9
        ],
        uiSettings: [
          AndroidUiSettings(
            toolbarColor: AppTheme.kPrimary,
            toolbarTitle: "Crop Image",
            statusBarColor: Colors.deepOrange.shade900,
            backgroundColor: Colors.white,
          ),
        ]);

    return File(croppedFile!.path);
  }

  static Future<void> pickAndCropImage(BuildContext ctx) async {
    final pickedImage = await pickImage();

    if (pickedImage != null) {
      // Crop the picked image
      File? croppedImage = await cropImage(File(pickedImage.path));

      if (croppedImage != null) {
        // Navigate to the upload page with the cropped image
        showDialog(
          context: ctx,
          builder: (context) => UploadPage(croppedImage: croppedImage),
        );
      }
    }
  }

  static Future<DateTime?> pickDateofBirth(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now().subtract(const Duration(days: 365 * 18)),
      lastDate: DateTime.now().subtract(const Duration(days: 365 * 18)),
      firstDate: DateTime(1900),
    );
    if (pickedDate != null) {
      debugPrint(pickedDate.day.toString());
      return pickedDate;
    }
    return null;
  }

  void showSelectionAnimation(BuildContext context, Offset cardPosition) {
    showDialog(
      context: context,
      builder: (context) => Stack(
        children: [
          Positioned(
            top: cardPosition.dy + 50, // Adjust position as needed
            left: cardPosition.dx + 50,
            child: AnimatedTextKit(
              animatedTexts: [
                TyperAnimatedText('You picked the user!',
                    textStyle:
                        const TextStyle(fontSize: 24, color: Colors.green),
                    speed: const Duration(milliseconds: 150)),
              ],
              totalRepeatCount: 2,
            ),
          ),
          // ... other dialog content if needed
        ],
      ),
    );
  }

  static Future<String?> getAddressFromCoordinates(
      double latitude, double longitude) async {
    try {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(latitude, longitude);
      if (placemarks.isNotEmpty) {
        Placemark placemark = placemarks[0];
        debugPrint('${placemark.locality},${placemark.administrativeArea}');
        return '${placemark.locality} , ${placemark.administrativeArea}';
      }
    } catch (e) {
      debugPrint('Error: $e');
    }
    return null;
  }

  static File? onImageSelection(int index, BuildContext context) {
    File? croppedImage;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: const Text("Select an Image"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();
              final image = await ProfileFunctions.pickImage();
              croppedImage =
                  await ProfileFunctions.cropImage(File(image!.path));

              // setState(() {
              //   _selectedImages[index] = File(croppedImage!.path);
              // });

              BlocProvider.of<FirebaseDataBloc>(context).add(
                FirebaseDataPhotoChanged(
                  XFile(croppedImage!.path),
                  index,
                ),
              );
            },
            child: const Text("Continue"),
          ),
        ],
      ),
    );
    return croppedImage;
  }
}
