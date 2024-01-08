import 'dart:async';
import 'package:flutter/material.dart';
import 'package:ipicku_dating_app/data/repositories/user_repositories.dart';
import 'package:ipicku_dating_app/presentation/login/login.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(
        const Duration(seconds: 8),
        () => Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) =>  SignInPage(userRepository: UserRepository(),)),
              (route) => false,
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(5, 0, 30, 1.0),
      body: Center(
        child: Image.asset('assets/images/logo_light.png',
            width: MediaQuery.of(context).size.height),
      ),
    );
  }
}
