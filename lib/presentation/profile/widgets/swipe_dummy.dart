import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ipicku_dating_app/data/repositories/local.dart';
import 'package:ipicku_dating_app/data/repositories/push_notifi_service.dart';
import 'package:ipicku_dating_app/data/repositories/user_repositories.dart';
import 'package:ipicku_dating_app/domain/matches_data_bloc/matches_data_bloc.dart';
import 'package:ipicku_dating_app/domain/notifications/notifications_bloc.dart';
import 'package:ipicku_dating_app/presentation/homepage/widgets/user_interests_widget.dart';
import 'package:ipicku_dating_app/presentation/profile/user_profile/details_section.dart';
import 'package:ipicku_dating_app/presentation/profile/user_profile/user_image_section.dart';
import 'package:ipicku_dating_app/presentation/ui_utils/colors.dart';
import 'package:ipicku_dating_app/presentation/homepage/widgets/date_details_section.dart';
import 'package:swipe_cards/swipe_cards.dart';

class DummySwipe extends StatefulWidget {
  final List<Map<String, dynamic>> userProfile;
  final Size size;

  const DummySwipe({
    Key? key,
    required this.userProfile,
    required this.size,
  }) : super(key: key);

  @override
  State<DummySwipe> createState() => _DummySwipeState();
}

class _DummySwipeState extends State<DummySwipe> {
  late List<SwipeItem> _swipeItems;
  late MatchEngine _matchEngine;
  late List<Map<String, dynamic>> _names;

  @override
  void initState() {
    _swipeItems = [];
    _names = List.from(widget.userProfile);
    getnewList(_names);
    _matchEngine = MatchEngine(swipeItems: _swipeItems);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8.0),
      decoration: const BoxDecoration(
        gradient: LinearGradient(colors: [
          Color.fromRGBO(115, 0, 255, 0.894),
          Color.fromRGBO(241, 4, 75, 0.898)
        ]),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Container(
        height: widget.size.height - 150,
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: SwipeCards(
          matchEngine: _matchEngine,
          rightSwipeAllowed: true,
          likeTag: const Icon(Icons.done),
          itemBuilder: _buildCard,
          onStackFinished: () {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text("Stack Finished"),
              duration: Duration(milliseconds: 500),
            ));
          },
          itemChanged: _onItemChanged,
          upSwipeAllowed: true,
          fillSpace: true,
        ),
      ),
    );
  }

  Widget _buildCard(BuildContext context, int index) {
    return Center(
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
                    height: widget.size.height - 150,
                    foregroundDecoration: BoxDecoration(
                      gradient: AppTheme.blackFade,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black26,
                      borderRadius: BorderRadius.circular(20),
                      image: DecorationImage(
                        image: getImageProvider(widget.userProfile[index]),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 50,
                    left: 20,
                    child: DateDetailsSection(
                      name: '${widget.userProfile[index]['name']}',
                      age: '${widget.userProfile[index]['age']}',
                      bio: '${widget.userProfile[index]['bio']}',
                    ),
                  )
                ],
              ),
              DetailsSection(
                data: widget.userProfile[index],
              ),
              const SizedBox(height: 16),
              (widget.userProfile[index]['photos'] != null &&
                      widget.userProfile[index]['photos'].isNotEmpty)
                  ? UserImageSection(
                      imageUrl: widget.userProfile[index]['photos'],
                    )
                  : const SizedBox(),
              const SizedBox(height: 16),
              (widget.userProfile[index]['Interests'] != null &&
                      widget.userProfile[index]['Interests'].isNotEmpty)
                  ? UserInterestWidget(
                      interests: widget.userProfile[index]['Interests'] ?? [],
                    )
                  : const SizedBox(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    onPressed: () {
                      _matchEngine.currentItem?.nope();
                    },
                    icon: const Icon(Icons.thumb_down),
                    color: Theme.of(context).appBarTheme.iconTheme?.color,
                    iconSize: 50,
                  ),
                  IconButton(
                    onPressed: () {
                      _matchEngine.currentItem?.like();
                    },
                    icon: ImageIcon(
                      const AssetImage('assets/images/logo_light.png'),
                      color: Theme.of(context).appBarTheme.iconTheme?.color,
                      size: 50,
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  void _onItemChanged(SwipeItem item, int index) {
    print("item: $item, index: $index");
  }

  CachedNetworkImageProvider getImageProvider(Map<String, dynamic> data) {
    if (data['photos'] != null && data['photos'].isNotEmpty) {
      return CachedNetworkImageProvider(
        data['photos'][0] ?? data['photoUrl'],
      );
    } else {
      return CachedNetworkImageProvider(data['photoUrl']);
    }
  }

  void getnewList(List<Map<String, dynamic>> _names) {
    for (int i = 0; i < _names.length; i++) {
      _swipeItems.add(SwipeItem(
        content: _names[i],
        likeAction: () async {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            backgroundColor: AppTheme.green,
            duration: Durations.medium4,
            behavior: SnackBarBehavior.floating,
            content: Text("User added as a pick"),
          ));
          BlocProvider.of<MatchesDataBloc>(context)
              .add(AddUserAsAPick(selectedUserId: _names[i]['uid']));

          debugPrint(_names[i].toString());

          await UserRepository().storeDeviceToken();

          final currentUserData = await UserRepository().getUserMap();

          if (_names[i]['deviceToken'] != null &&
              (_names[i]['notifications_picks'] ?? false)) {
            BlocProvider.of<NotificationsBloc>(context).add(
              NotificationReceivedEvent(
                'New Pick',
                "${currentUserData?['name']} picked you , Check My Picks list....",
                _names[i]['uid'],
                NotificationType.picks,
              ),
            );

            PushNotificationService().sendPushMessage(
              title: "New Notification",
              type: 'picks',
              body:
                  "${currentUserData?['name']} Picked You , Check on My Picks list....",
              token: _names[i]['deviceToken'],
            );
          }
        },
        nopeAction: () {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("Nope ${_names[i]['name']}"),
            duration: const Duration(milliseconds: 500),
          ));
        },
      ));
    }
  }
}
