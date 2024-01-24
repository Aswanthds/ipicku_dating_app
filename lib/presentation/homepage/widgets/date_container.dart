import 'package:appinio_swiper/appinio_swiper.dart';
import 'package:flutter/material.dart';
import 'package:ipicku_dating_app/constants.dart';
import 'package:ipicku_dating_app/data/repositories/user_repositories.dart';
import 'package:ipicku_dating_app/domain/bloc/matching_bloc.dart';
import 'package:ipicku_dating_app/presentation/homepage/progfilepage.dart';
import 'package:ipicku_dating_app/presentation/homepage/widgets/actions_button.dart';
import 'package:ipicku_dating_app/presentation/homepage/widgets/date_details_section.dart';

class DateProfileContainer extends StatelessWidget {
  final UserRepository userRepository;

  const DateProfileContainer({
    Key? key,
    required this.size,
    required this.userRepository,
    required this.state,
  }) : super(key: key);

  final Size size;
  final RandomProfileLoaded state;
  @override
  Widget build(BuildContext context) {
    return SwipeCardWidget(
        size: size, state: state, userRepository: userRepository);
  }
}

class SwipeCardWidget extends StatelessWidget {
  const SwipeCardWidget({
    super.key,
    required this.size,
    required this.state,
    required this.userRepository,
  });

  final Size size;
  final RandomProfileLoaded state;
  final UserRepository userRepository;

  @override
  Widget build(BuildContext context) {
    return AppinioSwiper(
        defaultDirection: AxisDirection.right,
        swipeOptions: const SwipeOptions.symmetric(horizontal: true),
        onEnd: () {
          const Text("No more Profiles");
        },
        onCardPositionChanged: (position) {
          debugPrint(position.angle.toString());
        },
        cardBuilder: (context, index) => Stack(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => UserProfileBottomSheet(
                          data: state.userProfile[index]),
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
                            borderRadius: BorderRadius.circular(20)),
                        decoration: BoxDecoration(
                          color: Colors.black26,
                          borderRadius: BorderRadius.circular(20),
                          image: DecorationImage(
                            image: NetworkImage(
                                "${state.userProfile[index]['photos'][0]}"),
                            fit: BoxFit.cover,
                            onError: (exception, stackTrace) {
                              NetworkImage(
                                  state.userProfile[index]['photoUrl']);
                            },
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
                      id: '${state.userProfile[index]['uid']}'),
                ),
                Positioned(
                  bottom: 90,
                  left: 40,
                  child: DateDetailsSection(
                    name: '${state.userProfile[index]['name']}',
                    age: '${state.userProfile[index]['age']}',
                    bio: '${state.userProfile[index]['bio']}',
                  ),
                )
              ],
            ),
        cardCount: state.userProfile.length);
  }
}
