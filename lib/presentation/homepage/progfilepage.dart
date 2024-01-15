import 'package:flutter/material.dart';
import 'package:ipicku_dating_app/presentation/profile/user_profile/details_section.dart';
import 'package:ipicku_dating_app/presentation/profile/user_profile/profile_details_action.dart';
import 'package:ipicku_dating_app/presentation/profile/user_profile/user_image_section.dart';

class UserProfileBottomSheet extends StatelessWidget {
  final String name;
  final int age;
  final String bio;
  final String imageUrl;

  const UserProfileBottomSheet({
    super.key,
    required this.name,
    required this.age,
    required this.bio,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  Container(
                    height: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                        bottomRight: Radius.circular(15),
                        bottomLeft: Radius.circular(15),
                      ),
                      color: Colors.black,
                      image: DecorationImage(
                        image: NetworkImage(imageUrl),
                        fit: BoxFit.fitHeight,
                      ),
                    ),
                  ),
                  IconButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      icon: const Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                      ))
                ],
              ),
              DetailsSection(name: name, age: age, bio: bio),
              const SizedBox(height: 16),
              UserImageSection(imageUrl: imageUrl),
              const SizedBox(height: 16),
              const ProfileDetailsAction(),
            ],
          ),
        ),
      ),
    );
  }
}
