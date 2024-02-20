import 'package:flutter/material.dart';
import 'package:ipicku_dating_app/presentation/profile/user_profile/image_preview.dart';

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
                  fontWeight: FontWeight.w300,
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
      Navigator.of(context).push(_createImagePreviewRoute(imgUrl));
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
              image: NetworkImage(imgUrl),
              fit: BoxFit.cover,
            ),
          ),
        ),
      ],
    ),
  );
}

Route _createImagePreviewRoute(String imgUrl) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) {
      return ImagePreviewPage(imageUrl: imgUrl);
    },
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(0.0, 1.0);
      const end = Offset.zero;
      const curve = Curves.easeInOut;
      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
      var offsetAnimation = animation.drive(tween);
      return SlideTransition(position: offsetAnimation, child: child);
    },
  );
}
