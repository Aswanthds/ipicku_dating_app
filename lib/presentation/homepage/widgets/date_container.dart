import 'package:flutter/material.dart';
import 'package:ipicku_dating_app/presentation/homepage/widgets/swipe_card.dart';
import 'package:ipicku_dating_app/data/repositories/user_repositories.dart';

class DateProfileContainer extends StatelessWidget {
  final UserRepository userRepository;

  const DateProfileContainer({
    Key? key,
    required this.size,
    required this.userRepository,
    required this.userProfile,
  }) : super(key: key);

  final Size size;
  final List<Map<String, dynamic>> userProfile;

  @override
  Widget build(BuildContext context) {
    return SwipeCardWidget(
      size: size,
      userProfile: userProfile,
      userRepository: userRepository,
    );
  }
}
