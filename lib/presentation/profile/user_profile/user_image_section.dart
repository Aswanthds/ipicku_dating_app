import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class UserImageSection extends StatelessWidget {
  final List<dynamic>? imageUrl;

  const UserImageSection({
    Key? key,
    required this.imageUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            "User Photos",
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 30),
          child: (imageUrl != null && imageUrl!.isNotEmpty)
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: List<Widget>.generate(
                    imageUrl!.length,
                    (index) => _buildUserPhoto(context, imageUrl![index]),
                  ),
                )
              : SizedBox(
                  height: 100,
                  child: Center(
                    child: Text(
                      'No user images available.',
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
  return GestureDetector(
    onTap: () {
      showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            child: Container(
              width: MediaQuery.of(context).size.width * 0.8,
              height: MediaQuery.of(context).size.height * 0.8,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: CachedNetworkImageProvider(imgUrl),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          );
        },
      );
    },
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(
            left: 20.0,
          ),
          child: Text(
            "Photos",
            style: Theme.of(context).textTheme.displayMedium,
          ),
        ),
        Container(
          height: 160,
          width: 100,
          margin: const EdgeInsets.only(
            left: 20,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            image: DecorationImage(
              image: CachedNetworkImageProvider(imgUrl),
              fit: BoxFit.cover,
            ),
          ),
        ),
      ],
    ),
  );
}
