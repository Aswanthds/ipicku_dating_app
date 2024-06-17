import 'package:shared_preferences/shared_preferences.dart';

//themes
Future<bool> isDark() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getBool("is_dark") ?? false;
}
Future<bool> isRomance() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getBool("is_romance") ?? false;
}

Future<void> setTheme(bool isDark) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setBool("is_dark", !isDark);
}

Future<void> setRomanceTheme(bool isromance)async{
   final SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setBool("is_romance", !isromance);
}
