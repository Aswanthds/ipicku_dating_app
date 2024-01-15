import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';

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

}
