import 'package:flutter/material.dart';

class AppTheme {
  static const Color kPrimary = Color.fromARGB(255, 5, 0, 30);
  static const Color primaryColor = Color(0xFF123456);
  static const Color secondaryColor = Color(0xFF789ABC);
  static const Color yellow = Color(0xFFDEF123);
  static const Color green = Colors.green;
  static const Color grey = Colors.grey;
  static Color grey300 = Colors.grey.shade300;
  static Color grey900 = Colors.grey.shade900;
  static const Color black = Colors.black;
  static const Color red = Colors.red;
  static const Color white = Colors.white;
  static const Color black26 = Color(0xFF262626); // Assuming black26 color
  static const Color blue = Colors.blue;

  static ThemeData lightTheme = ThemeData(
    primaryColor: primaryColor,
    scaffoldBackgroundColor: white,
    textTheme: const TextTheme(
      displayLarge: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: Colors.black, // Adjust the color as needed
      ),
      displayMedium: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.black, // Adjust the color as needed
      ),
      displaySmall: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.bold,
        color: Colors.black, // Adjust the color as needed
      ),
      bodyLarge: TextStyle(
        fontSize: 16,
        color: Colors.black, // Adjust the color as needed
      ),
      bodySmall: TextStyle(
        fontSize: 14,
        color: Colors.black, // Adjust the color as needed
      ),
    ),
  );

  static ThemeData darkTheme = ThemeData(
    primaryColor: Colors.black,
    scaffoldBackgroundColor: kPrimary,
    appBarTheme: const AppBarTheme(
      backgroundColor: kPrimary,
      titleTextStyle:
          TextStyle(color: white, fontSize: 22, fontWeight: FontWeight.bold),
      iconTheme: IconThemeData(color: white),
    ),
    dialogBackgroundColor: kPrimary,
    dialogTheme: const DialogTheme(
      titleTextStyle: TextStyle(
        color: white,
      ),
      contentTextStyle: TextStyle(
        color: white,
      ),
    ),
    textTheme: const TextTheme(
      bodySmall: TextStyle(color: white),
      titleLarge: TextStyle(color: white),
      titleMedium: TextStyle(color: white),
      titleSmall: TextStyle(color: black26),
      displayLarge: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: Colors.white, // Adjust the color as needed
      ),
      displayMedium: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.white, // Adjust the color as needed
      ),
      displaySmall: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.bold,
        color: Colors.white, // Adjust the color as needed
      ),
      bodyLarge: TextStyle(
        fontSize: 16,
        color: Colors.white, // Adjust the color as needed
      ),
    ),
    //   drawerTheme: DrawerThemeData(backgroundColor: kPrimary,),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: kPrimary,
      selectedItemColor: white,
      unselectedItemColor: grey,
      selectedIconTheme: IconThemeData(color: white),
      unselectedIconTheme: IconThemeData(color: grey),
    ),
  );

  static const TextStyle titleStyle = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: primaryColor,
  );

  static TextStyle bodyStyle = TextStyle(
    fontSize: 16,
    color: Colors.grey.shade800,
  );

  static ButtonStyle primaryButtonStyle = ButtonStyle(
    backgroundColor: MaterialStateProperty.all<Color>(primaryColor),
    foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
    padding: MaterialStateProperty.all<EdgeInsets>(
      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    ),
  );

  static LinearGradient whiteFade = const LinearGradient(
    begin: Alignment.bottomCenter,
    end: Alignment.center,
    colors: [Colors.white, Colors.transparent],
  );
  static LinearGradient contwhiteFade = const LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [Colors.white, Colors.transparent],
  );
  static LinearGradient blackFade = const LinearGradient(
    begin: Alignment.bottomCenter,
    end: Alignment.center,
    colors: [Colors.black, Colors.transparent],
  );
}
