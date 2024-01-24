import 'package:flutter/material.dart';
import 'package:ipicku_dating_app/constants.dart';
import 'package:ipicku_dating_app/presentation/profile/user_profile/details_section.dart';
import 'package:ipicku_dating_app/presentation/profile/user_profile/profile_details_action.dart';
import 'package:ipicku_dating_app/presentation/profile/user_profile/user_image_section.dart';

class UserProfileBottomSheet extends StatelessWidget {
  final Map<String, dynamic> data;

  const UserProfileBottomSheet({
    super.key,
    required this.data,
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
                      color: AppTheme.black,
                      image: DecorationImage(
                        image: NetworkImage(data['photoUrl']),
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
                        color: AppTheme.white,
                      ))
                ],
              ),
              DetailsSection(
                  name: data['name'], age: data['age'], bio: data['bio'] ?? ''),
              const SizedBox(height: 16),
              UserImageSection(imageUrl: data['photos']),
              const SizedBox(height: 16),
              const ProfileDetailsAction(),
            ],
          ),
        ),
      ),
    );
  }
}
