import 'package:flutter/material.dart';
import 'package:ipicku_dating_app/data/repositories/user_repositories.dart';
import 'package:ipicku_dating_app/presentation/profile/widgets/swipe_dummy.dart';

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
    return  DummySwipe(userProfile: userProfile,size: size,);
  
  }
}
