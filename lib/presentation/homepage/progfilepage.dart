import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ipicku_dating_app/data/repositories/local.dart';
import 'package:ipicku_dating_app/data/repositories/push_notifi_service.dart';
import 'package:ipicku_dating_app/data/repositories/user_repositories.dart';
import 'package:ipicku_dating_app/domain/matches_data_bloc/matches_data_bloc.dart';
import 'package:ipicku_dating_app/domain/notifications/notifications_bloc.dart';
import 'package:ipicku_dating_app/presentation/homepage/widgets/date_details_section.dart';
import 'package:ipicku_dating_app/presentation/homepage/widgets/user_interests_widget.dart';
import 'package:ipicku_dating_app/presentation/profile/user_profile/details_section.dart';
import 'package:ipicku_dating_app/presentation/profile/user_profile/user_image_section.dart';
import 'package:ipicku_dating_app/presentation/ui_utils/colors.dart';

class UserProfileBottomSheet extends StatefulWidget {
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
  State<UserProfileBottomSheet> createState() => _UserProfileBottomSheetState();
}

class _UserProfileBottomSheetState extends State<UserProfileBottomSheet> {
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
        child: Center(
          child: Card(
            color: Theme.of(context).scaffoldBackgroundColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      Container(
                        height: MediaQuery.of(context).size.height - 150,
                        foregroundDecoration: BoxDecoration(
                          gradient: AppTheme.blackFade,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black26,
                          borderRadius: BorderRadius.circular(20),
                          image: DecorationImage(
                            image: getImageProvider(widget.data),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 50,
                        left: 20,
                        child: DateDetailsSection(
                          name: '${widget.data['name']}',
                          age: '${widget.data['age']}',
                          bio: '${widget.data['bio']}',
                        ),
                      )
                    ],
                  ),
                  DetailsSection(
                    data: widget.data,
                  ),
                  const SizedBox(height: 16),
                  (widget.data['photos'] != null &&
                          widget.data['photos'].isNotEmpty)
                      ? UserImageSection(
                          imageUrl: widget.data['photos'],
                        )
                      : const SizedBox(),
                  const SizedBox(height: 16),
                  (widget.data['Interests'] != null &&
                          widget.data['Interests'].isNotEmpty)
                      ? UserInterestWidget(
                          interests: widget.data['Interests'] ?? [],
                        )
                      : const SizedBox(),
                 !widget.isMyPick ? IconButton(
                    onPressed: () async {
                      BlocProvider.of<MatchesDataBloc>(context).add(
                          AddUserAsAPick(
                              selectedUserId: widget.data['uid']));
                      final currentUserData =
                          await UserRepository().getUserData();
                      if (widget.data['deviceToken'] != null &&
                          (widget.data['notifications_picks'] ?? false)) {
                        BlocProvider.of<NotificationsBloc>(context).add(
                            NotificationReceivedEvent(
                                'New Pick',
                                "${currentUserData['name']} picked you , Check My Picks list....",
                                widget.data['uid'],
                                NotificationType.picks));
                        PushNotificationService().sendPushMessage(
                            title: "New Notification",
                            type: 'picks',
                            body:
                                "${currentUserData['name']} Picked You , Check on My Picks list....",
                            token: widget.data['deviceToken']);
                      }
                    },
                    icon: ImageIcon(
                      const AssetImage('assets/images/logo_light.png'),
                      color: Theme.of(context).appBarTheme.iconTheme?.color,
                      size: 50,
                    ),
                  ): const SizedBox()
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  CachedNetworkImageProvider getImageProvider(Map<String, dynamic> data) {
    if (data['photos'] != null && data['photos'].isNotEmpty) {
      return CachedNetworkImageProvider(data['photos'][0] ?? data['photoUrl']);
    } else {
      return CachedNetworkImageProvider(data['photoUrl']);
    }
  }
}
