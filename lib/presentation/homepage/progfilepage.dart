
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ipicku_dating_app/data/functions/login_functions.dart';
import 'package:ipicku_dating_app/domain/matches_data_bloc/matches_data_bloc.dart';
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
               
              ],
            ),
          ),
        ),
        floatingActionButton: FutureBuilder(
            future: CheckFunctions.isMutualPick(data['uid']),
            builder: (context, value) {
              return Wrap(
                direction: Axis.vertical,
                children: [
                  // Visibility(
                  //   visible: value.data ?? true && !isMyPick,
                  //   child: ProfileDetailsAction(
                  //     selected: data['uid'],
                  //     userid: userid,
                  //   ),
                  // ),
                  // const SizedBox(
                  //   height: 20,
                  // ),
                  Visibility(
                    visible: !isMyPick,
                    child: IconButton.filled(
                      onPressed: () async {
                        BlocProvider.of<MatchesDataBloc>(context)
                            .add(AddUserAsAPick(selectedUserId: data['uid']));
                      },
                      icon: const ImageIcon(
                        AssetImage("assets/images/logo_light.png"),
                        size: 45,
                      ),
                    ),
                  ),
                ],
              );
            }));
  }
}
