import 'package:flutter/material.dart';

class AppTheme {
  static const Color kprimary = Color.fromARGB(255, 5, 0, 30);
  static const Color primaryColor = Color(0xFF123456);
  static const Color secondaryColor = Color(0xFF789ABC);
  static const Color yellow = Color(0xFFDEF123);
  static const Color green = Colors.green;
  static const Color grey = Colors.grey;
  static const Color redAccent = Colors.redAccent;
  static const Color pinkAccent = Colors.pinkAccent;
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
      // Existing Styles
      displayLarge: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: black, // Adjust the color as needed
      ),
      displayMedium: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: black, // Adjust the color as needed
      ),
      displaySmall: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.bold,
        color: black, // Adjust the color as needed
      ),
      bodyLarge: TextStyle(
        fontSize: 16,
        color: black, // Adjust the color as needed
      ),
      bodySmall: TextStyle(
        fontSize: 14,
        color: black, // Adjust the color as needed
      ),
      headlineLarge: TextStyle(
        fontSize: 34, // Adjust the font size as needed
        fontWeight: FontWeight.w500,
        color: black, // Adjust the color as needed
      ),
      headlineMedium: TextStyle(
        fontSize: 24, // Adjust the font size as needed
        fontWeight: FontWeight.w500,
        color: black, // Adjust the color as needed
      ),
      headlineSmall: TextStyle(
        fontSize: 20, // Adjust the font size as needed
        fontWeight: FontWeight.w500,
        color: black, // Adjust the color as needed
      ),
      titleLarge: TextStyle(
        fontSize: 22, // Adjust the font size as needed
        fontWeight: FontWeight.w500,
        color: black, // Adjust the color as needed
      ),
      titleMedium: TextStyle(
        fontSize: 18, // Adjust the font size as needed
        fontWeight: FontWeight.w500,
        color: black, // Adjust the color as needed
      ),
      titleSmall: TextStyle(
        fontSize: 16, // Adjust the font size as needed
        fontWeight: FontWeight.w500,
        color: black, // Adjust the color as needed
      ),
    ),
  );

  static ThemeData darkTheme = ThemeData(
    primaryColor: black,
    scaffoldBackgroundColor: black,
    appBarTheme: const AppBarTheme(
      backgroundColor: black,
      titleTextStyle:
          TextStyle(color: white, fontSize: 22, fontWeight: FontWeight.bold),
      iconTheme: IconThemeData(color: white),
    ),
    dialogBackgroundColor: black,
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
      titleSmall: TextStyle(color: white),
      displayLarge: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: white, // Adjust the color as needed
      ),
      displayMedium: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: white, // Adjust the color as needed
      ),
      displaySmall: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.bold,
        color: white, // Adjust the color as needed
      ),
      bodyLarge: TextStyle(
        fontSize: 16,
        color: white, // Adjust the color as needed
      ),
      headlineLarge: TextStyle(
        fontSize: 34, // Adjust the font size as needed
        fontWeight: FontWeight.w500,
        color: white,
      ),
      headlineMedium: TextStyle(
        fontSize: 24, // Adjust the font size as needed
        fontWeight: FontWeight.w500,
        color: white,
      ),
      headlineSmall: TextStyle(
        fontSize: 20, // Adjust the font size as needed
        fontWeight: FontWeight.w500,
        color: white,
      ),
    ),
    //   drawerTheme: DrawerThemeData(backgroundColor: black,),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: black,
      selectedItemColor: white,
      unselectedItemColor: grey,
      selectedIconTheme: IconThemeData(color: white),
      unselectedIconTheme: IconThemeData(color: grey),
    ),
  );

  static ButtonStyle primaryButtonStyle = ButtonStyle(
    backgroundColor: WidgetStateProperty.all<Color>(primaryColor),
    foregroundColor: WidgetStateProperty.all<Color>(white),
    padding: WidgetStateProperty.all<EdgeInsets>(
      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    ),
  );

  static LinearGradient whiteFade = const LinearGradient(
    begin: Alignment.bottomCenter,
    end: Alignment.center,
    colors: [white, Colors.transparent],
  );
  static LinearGradient contwhiteFade = const LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [white, Colors.transparent],
  );
  static LinearGradient blackFade = const LinearGradient(
    begin: Alignment.bottomCenter,
    end: Alignment.center,
    colors: [black, Colors.transparent],
  );
}
