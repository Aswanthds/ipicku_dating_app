import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ipicku_dating_app/data/repositories/user_repositories.dart';
import 'package:ipicku_dating_app/domain/firebase_data/firebase_data_bloc.dart';
import 'package:ipicku_dating_app/domain/matching_bloc/matching_bloc.dart';
import 'package:ipicku_dating_app/presentation/main_page.dart';
import 'package:ipicku_dating_app/presentation/widgets/logo_widget.dart';

class WelcomePage extends StatelessWidget {
  final UserRepository repository;
  const WelcomePage({Key? key, required this.repository}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background gradient
          ClipPath(
            clipper: _BottomWaveClipper(),
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFFF2C94C), // Apricot
                    Color(0xFFF194FF), // Lavender
                  ],
                ),
              ),
            ),
          ),

          // Centered content
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
               LogoWidget(),
                const Text(
                  "Find your dates.",
                  style: TextStyle(
                    fontSize: 32.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 20.0),

                // Continue button
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              MainPageNav(repository: repository),
                        ),
                        (route) => false);
                    BlocProvider.of<MatchingBloc>(context)
                        .add(GetRandomUsers());
                    BlocProvider.of<FirebaseDataBloc>(context)
                        .add(FirebaseDataLoadedEvent());
                  }, // Replace with your navigation route
                  child: const Text(
                    "Continue",
                    style: TextStyle(fontSize: 18.0, color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    shape: const StadiumBorder(),
                    minimumSize:
                        Size(MediaQuery.of(context).size.width - 80, 50),
                    backgroundColor: const Color(0xFF9D38BD), // Purple
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Custom clipper for bottom wave effect
class _BottomWaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.moveTo(0.0, size.height * 0.75);
    path.quadraticBezierTo(
        size.width * 0.25, size.height, size.width * 0.5, size.height * 0.75);
    path.quadraticBezierTo(
        size.width * 0.75, size.height * 0.5, size.width, size.height * 0.75);
    path.lineTo(size.width, size.height);
    path.lineTo(0.0, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(_BottomWaveClipper oldClipper) => false;
}
