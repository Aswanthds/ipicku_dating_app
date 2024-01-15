import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ipicku_dating_app/data/repositories/user_repositories.dart';
import 'package:ipicku_dating_app/domain/auth_bloc/authentication_bloc.dart';
import 'package:ipicku_dating_app/presentation/log_in/login.dart';

const kPrimary = Color.fromRGBO(5, 0, 30, 0.8);
LinearGradient whiteFade = const LinearGradient(
  begin: Alignment.bottomCenter,
  end: Alignment.center,
  colors: [Colors.white, Colors.transparent],
);
LinearGradient blackFade = const LinearGradient(
  begin: Alignment.bottomCenter,
  end: Alignment.center,
  colors: [Colors.black, Colors.transparent],
);

SnackBar successCoustomSnackBar(String message) {
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

SnackBar errorCoustomSnackBar(String message) {
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

const failedSignUp = SnackBar(
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
const submitiingSignUp = SnackBar(
  duration: Duration(seconds: 3),
  content: Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: <Widget>[
      Text("Signing up..."),
      CircularProgressIndicator(),
    ],
  ),
);
Future<void> showLogoutDialog(
    BuildContext context, UserRepository repository) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        title: const Text(
          'Logout',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20.0,
          ),
        ),
        content: const Text('Are you sure you want to log out?'),
        actions: <Widget>[
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
              // Implement your logout logic here

              BlocProvider.of<AuthenticationBloc>(context).add(LoggedOut());
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
      );
    },
  );
}

const outlineInputBorder = OutlineInputBorder(
  borderRadius: BorderRadius.all(
    Radius.circular(15),
  ),
  borderSide: BorderSide(
    color: Colors.grey,
    style: BorderStyle.solid,
  ),
);

const inputDecoration = InputDecoration(
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

const profilefailedSnackBar = SnackBar(
  backgroundColor: Colors.red,
  content: Text("Submitting your details failed"),
  behavior: SnackBarBehavior.floating,
);
const profileSucessSnackBar = SnackBar(
  content: Row(
    children: [
      Text("Details Submitted Succesfully"),
      Icon(EvaIcons.doneAll),
    ],
  ),
  behavior: SnackBarBehavior.floating,
);
