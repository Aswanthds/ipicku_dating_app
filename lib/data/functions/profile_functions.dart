import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';

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
}
