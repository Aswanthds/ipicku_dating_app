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
      child: SizedBox(
        child: Stack(
          children: [
            Card(
              child: Container(
                height: 280,
                width: 160,
                foregroundDecoration: BoxDecoration(
                  gradient: AppTheme.blackFade,
                ),
                decoration: BoxDecoration(
                    color: AppTheme.black26,
                    image: DecorationImage(
                      image: NetworkImage(data['photoUrl']),
                      fit: BoxFit.cover,
                    ),
                    borderRadius: BorderRadius.circular(15)),
              ),
            ),
            Positioned(
              bottom: 20,
              left: 12,
              child: Row(
                children: [
                  Text(
                    '${data['name'].toString().split(' ').first} , ${data['age'].toString()}',
                    style: const TextStyle(
                      color: AppTheme.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
