import 'package:flutter/material.dart';
import 'package:ipicku_dating_app/constants.dart';
import 'package:ipicku_dating_app/presentation/homepage/progfilepage.dart';

class DateProfileContainer extends StatelessWidget {
  const DateProfileContainer({
    super.key,
    required this.size,
  });

  final Size size;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.of(context).push(_createRoute());
      },
      child: Center(
        child: Hero(
          tag: "date-image",
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Container(
              height: size.height,
              width: size.width - 50,
              foregroundDecoration: BoxDecoration(
                  gradient: blackFade, borderRadius: BorderRadius.circular(20)),
              decoration: BoxDecoration(
                  color: Colors.black26,
                  borderRadius: BorderRadius.circular(20),
                  image: const DecorationImage(
                      image: NetworkImage(
                          "https://i.pinimg.com/236x/7f/30/bc/7f30bce838ae79bc1f85e8fd0717f1c7.jpg"),
                      fit: BoxFit.fill)),
            ),
          ),
        ),
      ),
    );
  }
  Route _createRoute() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) {
        return const UserProfileBottomSheet(
          name: "name",
          age: 20,
          bio: "KLLKLKLKOLKIOL",
          imageUrl:  "https://i.pinimg.com/236x/7f/30/bc/7f30bce838ae79bc1f85e8fd0717f1c7.jpg",
        );
      },
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.easeInOut;
        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        var offsetAnimation = animation.drive(tween);
        return SlideTransition(position: offsetAnimation, child: child);
      },
    );
  }
}
