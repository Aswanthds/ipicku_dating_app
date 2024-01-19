import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:ipicku_dating_app/domain/auth_bloc/authentication_bloc.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      BlocProvider.of<AuthenticationBloc>(context).add(AppStarted());
      
      LocationPermission.always;
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
