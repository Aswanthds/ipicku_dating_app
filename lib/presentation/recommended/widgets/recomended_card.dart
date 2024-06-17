import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:ipicku_dating_app/presentation/homepage/progfilepage.dart';
import 'package:ipicku_dating_app/presentation/ui_utils/colors.dart';

class RecommendedCard extends StatelessWidget {
  final String id;
  const RecommendedCard({
    super.key,
    required this.data,
    required this.id,
  });

  final Map<String, dynamic> data;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) =>
              UserProfileBottomSheet(data: data, userid: id, isMyPick: false),
        ));
        //debugPrint(data['location']);
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
        child: SizedBox(
          width: 200,
          // foregroundDecoration: BoxDecoration(
          //   gradient: AppTheme.blackFade,
          // ),
          child: Stack(
            children: [
              Container(
                margin: EdgeInsets.all(2.0),
                foregroundDecoration: BoxDecoration(
                  gradient: AppTheme.blackFade,
                  borderRadius: BorderRadius.circular(15),
                ),
                decoration: BoxDecoration(
                    color: AppTheme.black26,
                    image: DecorationImage(
                      image: CachedNetworkImageProvider(data['photoUrl']),
                      fit: BoxFit.cover,
                    ),
                    borderRadius: BorderRadius.circular(15)),
              ),
              Positioned(
                bottom: 20,
                left: 12,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      data['name'].toString().split(' ').first.toUpperCase(),
                      style: const TextStyle(
                          color: AppTheme.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20),
                    ),
                    Text(
                      data['age'].toString(),
                      style: const TextStyle(
                          color: AppTheme.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
/*
 
*/