import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ipicku_dating_app/data/functions/login_functions.dart';
import 'package:ipicku_dating_app/data/repositories/user_repositories.dart';
import 'package:ipicku_dating_app/domain/matches_data_bloc/matches_data_bloc.dart';
import 'package:ipicku_dating_app/presentation/chatpage/widget/chat_person.dart';
import 'package:ipicku_dating_app/presentation/homepage/widgets/user_interests_widget.dart';
import 'package:ipicku_dating_app/presentation/profile/user_profile/details_section.dart';
import 'package:ipicku_dating_app/presentation/profile/user_profile/profile_details_action.dart';
import 'package:ipicku_dating_app/presentation/profile/user_profile/user_image_section.dart';

class UserProfileBottomSheet extends StatelessWidget {
  final Map<String, dynamic> data;
  final String userid;
  final bool isMyPick;

  const UserProfileBottomSheet({
    super.key,
    required this.data,
    required this.userid,
    required this.isMyPick,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 70,
                      backgroundImage: NetworkImage(
                        data['photoUrl'],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    RichText(
                      text: TextSpan(
                        style: Theme.of(context).textTheme.displayLarge,
                        children: [
                          TextSpan(
                            text: "${data['name']}",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const TextSpan(text: " , "),
                          TextSpan(
                            text: "${data['age']} yrs old",
                            style: const TextStyle(
                              fontWeight: FontWeight.normal,
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              DetailsSection(
                data: data,
              ),
              const SizedBox(height: 16),
              UserImageSection(
                imageUrl: data['photos'],
              ),
              const SizedBox(height: 16),
              UserInterestWidget(
                interests: data['Interests'] ?? [],
              ),
              FutureBuilder<bool>(
                  future: CheckFunctions.isMutualPick(data['uid']),
                  builder: (context, snap) {
                    return Visibility(
                      visible: snap.data ?? false,
                      child: ProfileDetailsAction(
                        selected: data['uid'],
                        userid: userid,
                      ),
                    );
                  })
            ],
          ),
        ),
      ),
      floatingActionButton: (isMyPick)
          ? IconButton.filled(
              onPressed: () async {
                BlocProvider.of<MatchesDataBloc>(context)
                    .add(AddUserAsAPick(selectedUserId: data['uid']));
                Timer(Durations.short4, () async {
                  final userData = await UserRepository().getUserMap();
                  final users = await FirebaseFirestore.instance
                      .collection('users')
                      .doc(data['uid'])
                      .get();
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => ChatPagePerson(
                        currentUser: userData, selectedUser: users.data()),
                  ));
                });
              },
              icon: const ImageIcon(
                AssetImage("assets/images/logo_light.png"),
                size: 50,
              ),
            )
          : const SizedBox(),
    );
  }
}
