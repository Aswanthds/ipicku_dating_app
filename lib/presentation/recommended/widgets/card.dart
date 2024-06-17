import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class FitnessCard extends StatelessWidget {
  final String imagePath;
  final String title;
  final BoxFit? fit;
  final Widget toPage;
  const FitnessCard(
      {super.key,
      required this.imagePath,
      required this.title,
      required this.toPage,
      this.fit});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => toPage,
        ));
      },
      child: Container(
        height: 100,
        margin: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          gradient: const LinearGradient(colors: [
            Color.fromRGBO(115, 0, 255, 0.894),
            Color.fromRGBO(241, 4, 75, 0.898)
          ]),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Container(
          height: 65,
          margin: const EdgeInsets.all(1.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Theme.of(context).scaffoldBackgroundColor,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                imagePath,
                width: 60,
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                title,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontSize: 12,
                    ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
