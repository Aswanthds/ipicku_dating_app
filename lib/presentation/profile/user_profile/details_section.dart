import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ipicku_dating_app/constants.dart';
import 'package:ipicku_dating_app/data/functions/profile_functions.dart';

class DetailsSection extends StatelessWidget {
  const DetailsSection({
    Key? key,
    required this.data,
  }) : super(key: key);

  final Map<String, dynamic> data;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          ListTile(
            contentPadding:
                EdgeInsets.zero, // Remove ListTile's default padding
            title: Text("${data['name']} , ${data['age']}",
                style: Theme.of(context).textTheme.displayLarge),
          ),
          userDataListTile(EvaIcons.person, "${data['gender']}", context),
          userDataListTile(
            EvaIcons.bookmark,
            data['bio'] == "null" ? " " : "${data['bio']}",
            context,
          ),
          userDataListTile(
              EvaIcons.calendarOutline,
              DateFormat('dd - MMM - yyy')
                  .format((data['dob'] as Timestamp).toDate()),
              context),
          //userDataListTile(EvaIcons.calendarOutline, (data['dob'].toString())),

          FutureBuilder<String?>(
            future: ProfileFunctions.getAddressFromCoordinates(
              (data['location'] as GeoPoint).latitude,
              (data['location'] as GeoPoint).longitude,
            ),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text("Error: ${snapshot.error}");
              } else {
                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  minLeadingWidth: 2,
                  leading: const Icon(
                    Icons.location_on,
                    size: 18,
                    color: AppTheme.grey,
                  ),
                  title: Text(snapshot.data ?? "No address available",
                      style: Theme.of(context).textTheme.bodyLarge,),
                );
              }
            },
          ),
        ],
      ),
    );
  }

  userDataListTile(IconData person, String s, BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      minLeadingWidth: 2,
      leading: Icon(
        person,
        size: 18,
      ),
      title: Text(s, style: Theme.of(context).textTheme.bodyLarge),
    );
  }
}
