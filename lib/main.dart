import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ipicku_dating_app/data/repositories/user_repositories.dart';
import 'package:ipicku_dating_app/domain/auth_bloc/authentication_bloc.dart';
import 'package:ipicku_dating_app/domain/bloc/firebase_data_bloc.dart';
import 'package:ipicku_dating_app/domain/login_bloc/login_bloc.dart';
import 'package:ipicku_dating_app/domain/profile_bloc/profile_bloc.dart';
import 'package:ipicku_dating_app/domain/signup_bloc/sign_up_bloc.dart';
import 'package:ipicku_dating_app/presentation/log_in/login.dart';
import 'package:ipicku_dating_app/presentation/main_page.dart';
import 'package:ipicku_dating_app/presentation/sign_up/profile_signup.dart';
import 'package:ipicku_dating_app/presentation/splash_screen/splash_screen.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  final UserRepository userRepository = UserRepository();
  runApp(MultiBlocProvider(providers: [
    BlocProvider(
      create: (context) => ProfileBloc(userRepository),
    ),
    BlocProvider(
      create: (context) => AuthenticationBloc(userRepository: userRepository),
    ),
    BlocProvider(
      create: (context) => SignUpBloc(userRepository),
    ),
    BlocProvider(
      create: (context) => LoginBloc(userRepository: userRepository),
    ),
    BlocProvider(
      create: (context) => FirebaseDataBloc(userRepository),
    )
  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final UserRepository userRepository = UserRepository();

    return MaterialApp(
        title: 'IPickU Dating App | Where relations blossoms ',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: BlocBuilder<AuthenticationBloc, AuthenticationState>(
          builder: (context, state) {
            if (state is IntialAuthenticationState) {
              return const SplashScreen();
            }
            if (state is AuthenticationSuccess) {
              return MainPageNav(
                repository: userRepository,
              );
            }
            if (state is Unauthenticated) {
              return SignInPage(userRepository: userRepository);
            }
            if (state is AuthenticationSucessButNotSet) {
              return SignupProfilePage(
                userRepository: userRepository,
              );
            } else {
              return const SplashScreen();
            }
          },
        ));
  }
}
