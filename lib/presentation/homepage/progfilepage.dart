import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ipicku_dating_app/data/functions/login_functions.dart';
import 'package:ipicku_dating_app/data/repositories/local.dart';
import 'package:ipicku_dating_app/data/repositories/push_notifi_service.dart';
import 'package:ipicku_dating_app/data/repositories/user_repositories.dart';
import 'package:ipicku_dating_app/domain/matches_data_bloc/matches_data_bloc.dart';
import 'package:ipicku_dating_app/domain/notifications/notifications_bloc.dart';
import 'package:ipicku_dating_app/presentation/homepage/widgets/user_interests_widget.dart';
import 'package:ipicku_dating_app/presentation/profile/user_profile/details_section.dart';
import 'package:ipicku_dating_app/presentation/profile/user_profile/user_image_section.dart';
import 'package:ipicku_dating_app/presentation/ui_utils/colors.dart';

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
      body: BlocListener<MatchesDataBloc, MatchesDataState>(
       listener: (context, state) {
          if (state is DatePickedState) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                backgroundColor: AppTheme.green,
                duration: Durations.medium4,
                behavior: SnackBarBehavior.floating,
                content: Text("User added as a pick")));
          }
        },
        child: SafeArea(
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
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text(
                          data['bio'] == "null" ? " " : "${data['bio']}",
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.justify,
                        ),
                      ),
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
      ),
      floatingActionButton: FutureBuilder(
        future: CheckFunctions.isMutualPick(data['uid']),
        builder: (context, value) {
          return Wrap(
            direction: Axis.vertical,
            children: [
              Visibility(
                visible: !isMyPick,
                child: IconButton.filled(
                  onPressed: () async {
                    BlocProvider.of<MatchesDataBloc>(context)
                        .add(AddUserAsAPick(selectedUserId: data['uid']));
                    final currentUserData =
                        await UserRepository().getUserData();
                    if (data['deviceToken'] != null &&
                        (data['notifications_picks'] ?? false)) {
                      BlocProvider.of<NotificationsBloc>(context).add(
                          NotificationReceivedEvent(
                              'New Pick',
                              "${currentUserData?.name} picked you , Check My Picks list....",
                              data['uid'],
                              NotificationType.picks));
                      PushNotificationService().sendPushMessage(
                          title: "New Notification",
                          type: 'picks',
                          body:
                              "${currentUserData?.name} Picked You , Check on My Picks list....",
                          token: data['deviceToken']);
                    }
                  },
                  icon: const ImageIcon(
                    AssetImage("assets/images/logo_light.png"),
                    size: 45,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
