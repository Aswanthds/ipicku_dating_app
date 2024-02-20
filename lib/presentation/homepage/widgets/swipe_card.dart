import 'package:appinio_swiper/appinio_swiper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ipicku_dating_app/data/repositories/local.dart';
import 'package:ipicku_dating_app/data/repositories/push_notifi_service.dart';
import 'package:ipicku_dating_app/domain/notifications/notifications_bloc.dart';
import 'package:ipicku_dating_app/presentation/ui_utils/colors.dart';
import 'package:ipicku_dating_app/data/repositories/user_repositories.dart';
import 'package:ipicku_dating_app/presentation/homepage/progfilepage.dart';
import 'package:ipicku_dating_app/presentation/homepage/widgets/actions_button.dart';
import 'package:ipicku_dating_app/presentation/homepage/widgets/date_details_section.dart';
import 'package:ipicku_dating_app/presentation/widgets/empty_list.dart';

class SwipeCardWidget extends StatelessWidget {
  const SwipeCardWidget({
    Key? key,
    required this.size,
    required this.userProfile,
    required this.userRepository,
  }) : super(key: key);

  final Size size;
  final List<Map<String, dynamic>> userProfile;
  final UserRepository userRepository;

  @override
  Widget build(BuildContext context) {
    final AppinioSwiperController controller = AppinioSwiperController();
    if (userProfile.isEmpty) {
      // Handle the case when userProfile is empty (zero length)
      return const EmptyListPage(text: "No profiles available");
    }

    return AppinioSwiper(
      controller: controller,
      defaultDirection: AxisDirection.right,
      swipeOptions: const SwipeOptions.symmetric(horizontal: true),
      onEnd: () {
        debugPrint("No more profiles");
      },
      cardBuilder: (context, index) => Stack(
        children: [
          GestureDetector(
            onTap: () async {
              final id = await userRepository.getUser();
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => UserProfileBottomSheet(
                  data: userProfile[index],
                  userid: id,
                  isMyPick: false,
                ),
              ));
            },
            child: Center(
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Container(
                  height: size.height,
                  width: size.width - 50,
                  foregroundDecoration: BoxDecoration(
                    gradient: AppTheme.blackFade,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black26,
                    borderRadius: BorderRadius.circular(20),
                    image: DecorationImage(
                      image: getImageProvider(userProfile[index]),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: MediaQuery.of(context).size.width / 2 - 30,
            child: ActionsButton(
              repository: userRepository,
              id: '${userProfile[index]['uid']}',
              onActionPressed: () async {
                if (userProfile.isNotEmpty) {
                  controller.swipeLeft();
                }
                debugPrint(userProfile[index].toString());
                await userRepository.storeDeviceToken();
                final currentUserData = await userRepository.getUserData();
                if (userProfile[index]['deviceToken'] != null &&
                    (userProfile[index]['notifications_picks'] ?? false)) {
                  BlocProvider.of<NotificationsBloc>(context).add(
                      NotificationReceivedEvent(
                          'New Pick',
                          "${currentUserData?.name} picked you , Check My Picks list....",
                          userProfile[index]['uid'],
                          NotificationType.picks));
                  PushNotificationService().sendPushMessage(
                      title: "New Notification",
                      type: 'picks',
                      body: "${currentUserData?.name} Picked You , Check on My Picks list....",
                      token: userProfile[index]['deviceToken']);
                }
              },
            ),
          ),
          Positioned(
            bottom: 90,
            left: 40,
            child: DateDetailsSection(
              name: '${userProfile[index]['name']}',
              age: '${userProfile[index]['age']}',
              bio: '${userProfile[index]['bio']}',
            ),
          )
        ],
      ),
      cardCount: userProfile.length,
    );
  }

  ImageProvider getImageProvider(Map<String, dynamic> data) {
    if (data['photos'] != null && data['photos'].isNotEmpty) {
      return NetworkImage(data['photos'][0] ?? data['photoUrl']);
    } else {
      return NetworkImage(data['photoUrl']);
    }
  }
}
//nothing