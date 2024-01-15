import 'package:flutter/material.dart';
import 'package:ipicku_dating_app/presentation/profile/user_profile/image_preview.dart';

class UserImageSection extends StatelessWidget {
final  String imageUrl;

  
  const UserImageSection({
    super.key, required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return  Padding(
      padding: const EdgeInsets.only(top: 30),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildUserPhoto(context,imageUrl),
          _buildUserPhoto(context,imageUrl),
          _buildUserPhoto(context, imageUrl),
        ],
      ),
    );
  }
}
  Widget _buildUserPhoto(BuildContext context , String imgUrl) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(_createImagePreviewRoute(imgUrl));
      },
      child: Container(
        height: 160,
        width: 100,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          image: DecorationImage(
            image: NetworkImage(imgUrl), // Use the same image for now
            fit: BoxFit.cover,
          ),
        ),
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
        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        var offsetAnimation = animation.drive(tween);
        return SlideTransition(position: offsetAnimation, child: child);
      },
    );
  }

