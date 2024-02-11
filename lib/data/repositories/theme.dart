import 'package:shared_preferences/shared_preferences.dart';

//themes
Future<bool> isDark() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getBool("is_dark") ?? false;
}

Future<void> setTheme(bool isDark) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setBool("is_dark", !isDark);
}
//likes
Future<bool> isLikesOn() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getBool("is_likes_on") ?? false;
}

Future<void> setLikesOn(bool isLikes) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setBool("is_likes_on", !isLikes);
}
// picks
Future<bool> isPicksOn() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getBool("is_likes_on") ?? false;
}

Future<void> setPicksOn(bool isLikes) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setBool("is_likes_on", !isLikes);
}
// messages
Future<bool> isMessagesOn() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getBool("is_likes_on") ?? false;
}

Future<void> setMessages(bool isLikes) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setBool("is_likes_on", !isLikes);
}
//recomendations
Future<bool> isRecomendations() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getBool("is_likes_on") ?? false;
}

Future<void> setRecommendations(bool isLikes) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setBool("is_likes_on", !isLikes);
}
