import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import 'package:image_picker/image_picker.dart';
import 'package:ipicku_dating_app/main.dart';
import 'package:ipicku_dating_app/presentation/chatpage/widget/user_photso.dart';

class ProfileFunctions {
  static Future<List<String>> showImages(String user1, String user2) async {
    List<String> data = [];
    try {
      List<String> ids = [user1, user2];
      ids.sort();
      String chatRoom = ids.join('_');
      final storageRef = await FirebaseStorage.instance
          .ref()
          .child('chat_rooms_photos')
          .child(chatRoom)
          .listAll();
      final urllist = storageRef.items;
      for (var dat in urllist) {
        data.add(await dat.getDownloadURL());
      }
      debugPrint(data.toString());
      return data;
    } catch (e) {
      debugPrint(e.toString());
      return [];
    }
  }

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

  static Future<String?> getLocation() async {
    if (!await isLocationServiceEnabled()) {
      showEnableLocationSnackbar();
    }

    LocationPermission permission = await requestLocationPermission();
    handlePermission(permission);

    if (permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse) {
      Position? position = await getCurrentLocation();
      if (position != null) {
        return '${position.latitude},${position.longitude}';
      }
    }

    return null;
  }

  static Future<Position?> getCurrentLocation() async {
    if (!await isLocationServiceEnabled()) {
      showEnableLocationSnackbar();
    }

    LocationPermission permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse) {
      return await Geolocator.getCurrentPosition();
    }
    return null;
  }

  static void showEnableLocationSnackbar() {
    // Show a snackbar informing the user about disabled location service
    // You can customize this snackbar based on your app's UI/UX
    ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
      SnackBar(
        content: const Text('Please enable location service to proceed.'),
        duration: const Duration(seconds: 3),
        action: SnackBarAction(
          label: 'SETTINGS',
          onPressed: () {
            // Open device settings to enable location service
            Geolocator.openAppSettings();
          },
        ),
      ),
    );
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

  static Future<DateTime?> pickDateofBirth(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      confirmText: "Add your D.O.B",
      currentDate: DateTime.now(),
      initialDate: DateTime.now().subtract(const Duration(days: 365 * 18)),
      lastDate: DateTime.now().subtract(const Duration(days: 365 * 18)),
      firstDate: DateTime(1900),
    );
    if (pickedDate != null) {
      debugPrint(pickedDate.day.toString());
      return pickedDate.toLocal();
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
            child: const Text('You picked the user!'),
          ),
          // ... other dialog content if needed
        ],
      ),
    );
  }

  // static Future<String?> getAddressFromCoordinates(
  //     double latitude, double longitude,
  //     [String? userId]) async {
  //   try {
  //     List<Placemark> placemarks =
  //         await placemarkFromCoordinates(latitude, longitude);
  //     if (placemarks.isNotEmpty) {
  //       Placemark placemark = placemarks[0];
  //       debugPrint('${placemark.locality},${placemark.administrativeArea}');
  //       if (userId != null) {
  //         // BlocProvider.of<FirebaseDataBloc>(context).add(UpdateUserFieldEvent(
  //         //     'location',
  //         //     '${placemark.locality} , ${placemark.administrativeArea}'));
  //         FirebaseFirestore.instance.collection("users").doc(userId).update(
  //           {
  //             'location':
  //                 '${placemark.locality} , ${placemark.administrativeArea}'
  //           },
  //         );
  //       }
  //       return '${placemark.locality} , ${placemark.administrativeArea}';
  //     }
  //   } catch (e) {
  //     debugPrint('Error: $e');
  //   }
  //   return null;
  // }

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
              final image = await ProfileFunctions.pickImage();

              if (image != null) {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => CustomUsersPhotoCrop(
                    path: image,
                    title: 'Profile picture',
                    index: index,
                  ),
                ));
              }
            },
            child: const Text("Continue"),
          ),
        ],
      ),
    );
    return croppedImage;
  }

  static Future<LocationPermission> checkPermission() async {
    var permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    } else {
      permission = LocationPermission.whileInUse;
    }
    return permission;
  }

  static Future<bool> isLocationServiceEnabled() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    return serviceEnabled;
  }

  static Future<LocationPermission> requestLocationPermission() async {
    if (!await isLocationServiceEnabled()) {
      // Handle case where location service is disabled
      return LocationPermission.denied;
    }

    LocationPermission permission = await Geolocator.requestPermission();
    return permission;
  }

  static void handlePermission(LocationPermission permission) {
    switch (permission) {
      case LocationPermission.always:
        // Permission granted for both foreground and background usage
        break;
      case LocationPermission.whileInUse:
        // Permission granted only while the app is in the foreground
        break;
      case LocationPermission.denied:
        // Permission denied
        break;
      case LocationPermission.deniedForever:
        break;
      case LocationPermission.unableToDetermine:
        break;
    }
  }
}
