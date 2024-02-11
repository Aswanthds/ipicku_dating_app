import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ipicku_dating_app/data/repositories/local_notifications.dart';
import 'package:ipicku_dating_app/data/repositories/matches_repo.dart';
import 'package:ipicku_dating_app/data/repositories/push_notifi_service.dart';
import 'package:ipicku_dating_app/data/repositories/user_repositories.dart';
import 'package:ipicku_dating_app/domain/auth_bloc/authentication_bloc.dart';
import 'package:ipicku_dating_app/domain/matches_data_bloc/matches_data_bloc.dart';
import 'package:ipicku_dating_app/domain/firebase_data/firebase_data_bloc.dart';
import 'package:ipicku_dating_app/domain/login_bloc/login_bloc.dart';
import 'package:ipicku_dating_app/domain/matching_bloc/matching_bloc.dart';
import 'package:ipicku_dating_app/domain/messages/messages_bloc.dart';
import 'package:ipicku_dating_app/domain/messaging/messaging_bloc.dart';
import 'package:ipicku_dating_app/domain/notifications/notifications_bloc.dart';

import 'package:ipicku_dating_app/domain/profile_bloc/profile_bloc.dart';
import 'package:ipicku_dating_app/domain/signup_bloc/sign_up_bloc.dart';
import 'package:ipicku_dating_app/domain/theme/theme_bloc.dart';
import 'package:ipicku_dating_app/domain/theme/theme_event.dart';
import 'package:ipicku_dating_app/domain/video_chat/videochat_bloc.dart';
import 'package:ipicku_dating_app/presentation/homepage/notifications_page.dart';
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
  await NotificationService().init();
  await PushNotificationService().initPushNotification();
  PushNotificationService().showNotificationtoUSer();
  final UserRepository userRepository = UserRepository();
  final MatchesRepository repository = MatchesRepository();
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
    ),
    BlocProvider(
      create: (context) => MatchesDataBloc(repository),
    ),
    BlocProvider(
      create: (context) => MatchingBloc(repository),
    ),
    BlocProvider(
      create: (context) => ThemeBloc()..add(InitialThemeSetEvent()),
    ),
    BlocProvider(create: (context) => MessagesBloc()..add(GetChatList())),
    BlocProvider(create: (context) => MessagingBloc()),
    BlocProvider(create: (context) => NotificationsBloc()),
    BlocProvider(create: (context) => VideochatBloc()),
  ], child: const MyApp()));
}

final navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final UserRepository userRepository = UserRepository();

    return BlocBuilder<ThemeBloc, ThemeData>(
      builder: (context, state) {
        return MaterialApp(
            navigatorKey: navigatorKey,
            title: 'IPickU Dating App ',
            debugShowCheckedModeBanner: false,
            theme: state,
            routes: {
              NotificationsPage.route: (context) => const NotificationsPage(
                    data: [],
                  )
            },
            home: BlocBuilder<AuthenticationBloc, AuthenticationState>(
              builder: (context, state) {
                if (state is IntialAuthenticationState) {
                  return const SplashScreen();
                }
                if (state is AuthenticationSuccess) {
                  Future.delayed(const Duration(seconds: 10));
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
      },
    );
  }
}


//p1MtRAEJEctemiDYoP1TXdnM_-nhW-nulNlZi2gaeRQ