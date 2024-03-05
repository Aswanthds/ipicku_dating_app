import 'package:flutter/material.dart';

class UserInterestWidget extends StatelessWidget {
  final List<dynamic>? interests;

  const UserInterestWidget({
    Key? key,
    required this.interests,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            "User Interests",
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w300,
                ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 10),
          child: (interests != null && interests!.isNotEmpty)
              ? SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: List<Widget>.generate(
                      interests!.length,
                      (index) => _buildUserPhoto(context, interests![index]),
                    ),
                  ),
              )
              : Center(
                  child: SizedBox(
                    height: 160,
                    child: Text(
                      'No user interests available.',
                      style: Theme.of(context).textTheme.displaySmall,
                    ),
                  ),
                ),
        ),
      ],
    );
  }
}

Widget _buildUserPhoto(BuildContext context, String imgUrl) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Chip(label: Text(imgUrl)),
  );
}
