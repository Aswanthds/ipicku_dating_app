import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ipicku_dating_app/data/repositories/user_repositories.dart';
import 'package:ipicku_dating_app/domain/auth_bloc/authentication_bloc.dart';
import 'package:ipicku_dating_app/presentation/log_in/login.dart';

class AppTheme {
  static const Color kPrimary = Color.fromRGBO(5, 0, 30, 0.8);
  static const Color primaryColor = Color(0xFF123456);
  static const Color secondaryColor = Color(0xFF789ABC);
  static const Color yellow = Color(0xFFDEF123);
  static const Color green = Colors.green;
  static const Color grey = Colors.grey;
  static  Color grey300 = Colors.grey.shade300;
  static  Color grey900 = Colors.grey.shade900;
  static const Color black = Colors.black;
  static const Color red = Colors.red;
  static const Color white = Colors.white;
  static const Color black26 = Color(0xFF262626); // Assuming black26 color
  static const Color blue = Colors.blue;

  static ThemeData lightTheme = ThemeData(
    primaryColor: primaryColor,
    scaffoldBackgroundColor: white,
  );

  static ThemeData darkTheme = ThemeData(
    primaryColor: Colors.black,
    scaffoldBackgroundColor: Colors.grey[900],
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

  static LinearGradient blackFade = const LinearGradient(
    begin: Alignment.bottomCenter,
    end: Alignment.center,
    colors: [Colors.black, Colors.transparent],
  );
}

class SnackBarManager {
  static SnackBar successCustomSnackBar(String message) {
    return SnackBar(
      backgroundColor: Colors.green,
      duration: const Duration(seconds: 3),
      content: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(message),
          const Icon(Icons.done),
        ],
      ),
    );
  }

  static SnackBar errorCustomSnackBar(String message) {
    return SnackBar(
      backgroundColor: Colors.red,
      duration: const Duration(seconds: 3),
      content: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(message),
          const Icon(Icons.error),
        ],
      ),
    );
  }

  static const SnackBar failedSignUp = SnackBar(
    backgroundColor: Colors.red,
    duration: Duration(seconds: 3),
    content: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text("Sign Up Failed"),
        Icon(Icons.error),
      ],
    ),
  );

  // Add other snack bars as needed
}

class DialogManager {
  static Future<void> showLogoutDialog(
      BuildContext context, UserRepository repository) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Container(
            height: 300.0,
            width: 300.0,
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  height: 80.0,
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Center(
                    child: Text(
                      'Logout Account',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16.0),
                const Text(
                  'Are you sure you want to log out?',
                  style: TextStyle(fontSize: 16.0),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton(
                      child: const Text(
                        'Cancel',
                        style: TextStyle(color: Colors.black),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    TextButton.icon(
                      icon: const Icon(
                        EvaIcons.logOut,
                        color: Colors.red,
                      ),
                      label: const Text(
                        'Logout',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        ),
                      ),
                      onPressed: () {
                        BlocProvider.of<AuthenticationBloc>(context)
                            .add(LoggedOut());
                        Navigator.of(context).pop();

                        Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                              builder: (context) =>
                                  SignInPage(userRepository: repository),
                            ),
                            (route) => false);
                      },
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }

  static Future<void> showDeleteAccountDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Container(
            height: 300.0,
            width: 300.0,
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  height: 80.0,
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Center(
                    child: Text(
                      'Delete Account',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16.0),
                const Text(
                  'Are you sure you want to delete your account?',
                  style: TextStyle(fontSize: 16.0),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      style: ElevatedButton.styleFrom(
                          shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)))),
                      child: const Text('Cancel',
                          style: TextStyle(color: Colors.black)),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        BlocProvider.of<AuthenticationBloc>(context)
                            .add(DeleteAccount());
                        Navigator.of(context).pop();
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)))),
                      child: const Text('Delete',
                          style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
  /*

  */
}

class InputDecorationManager {
  static const OutlineInputBorder outlineInputBorder = OutlineInputBorder(
    borderRadius: BorderRadius.all(
      Radius.circular(15),
    ),
    borderSide: BorderSide(
      color: Colors.grey,
      style: BorderStyle.solid,
    ),
  );

  static const InputDecoration inputDecoration = InputDecoration(
    labelText: 'Gender',
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.all(
        Radius.circular(15),
      ),
      borderSide: BorderSide(
        color: Colors.red,
        style: BorderStyle.solid,
      ),
    ),
    labelStyle: TextStyle(color: Colors.white),
    focusedBorder: outlineInputBorder,
    focusColor: Colors.grey,
  );

  // Add other input decorations as needed
}

class SnackBarConstants {
  static const SnackBar profileFailedSnackBar = SnackBar(
    backgroundColor: Colors.red,
    content: Text("Submitting your details failed"),
    behavior: SnackBarBehavior.floating,
  );

  static const SnackBar profileSuccessSnackBar = SnackBar(
    backgroundColor: Colors.green,
    content: Row(
      children: [
        Text("Details Submitted Successfully"),
        Icon(EvaIcons.doneAll),
      ],
    ),
    behavior: SnackBarBehavior.floating,
  );

  static const SnackBar profileLoading = SnackBar(
    backgroundColor: Colors.grey,
    content: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text("Details are submitting....."),
        CircularProgressIndicator(
          strokeWidth: 2.0,
          color: Colors.white,
        ),
      ],
    ),
    behavior: SnackBarBehavior.floating,
  );

  static const SnackBar profileGetSuccess = SnackBar(
    backgroundColor: Colors.grey,
    content: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text("Details are fetching....."),
        CircularProgressIndicator(
          strokeWidth: 2.0,
          color: Colors.white,
        ),
      ],
    ),
    behavior: SnackBarBehavior.floating,
  );
}
