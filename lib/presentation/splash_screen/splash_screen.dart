import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ipicku_dating_app/domain/auth_bloc/authentication_bloc.dart';
import 'package:permission_handler/permission_handler.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    [Permission.location,Permission.notification].request();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_)async {
      BlocProvider.of<AuthenticationBloc>(context).add(AppStarted());
    });
  
    return Scaffold(
      backgroundColor: const Color.fromRGBO(5, 0, 30, 1.0),
      body: Center(
        child: Image.asset(
          'assets/images/logo_light.png',
          width: 200,
        ),
      ),
    );
  }
}
