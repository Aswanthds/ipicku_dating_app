import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ipicku_dating_app/presentation/ui_utils/colors.dart';
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
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "User Details",
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
          userDataListTile(
              EvaIcons.calendarOutline,
              DateFormat('dd - MMM - yyy')
                  .format((data['dob'] as Timestamp).toDate()),
              context),
          userDataListTile(EvaIcons.person, "${data['gender']}", context),
          // userDataListTile(
          //   EvaIcons.activityOutline,
          //   data['bio'] == "null" ? " " : "${data['bio']}",
          //   context,
          // ),
          (data['location'] != null) ? _locationDataTile() : const SizedBox()
        ],
      ),
    );
  }

  FutureBuilder<String?> _locationDataTile() {
    return FutureBuilder<String?>(
      future: ProfileFunctions.getAddressFromCoordinates(
          (data['location'] as GeoPoint?)?.latitude ?? 0.0,
          (data['location'] as GeoPoint?)?.longitude ?? 0.0),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // While the future is still resolving, show a loading indicator.
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          // If there's an error in fetching the data, display the error message.
          return Text("Error: ${snapshot.error}");
        } else {
          // If the data retrieval is successful, display it in a ListTile.
          return Container(
              decoration: BoxDecoration(
                border: Border.symmetric(
                    horizontal: BorderSide(
                        width: 2.0,
                        style: BorderStyle.solid,
                        color:
                            Theme.of(context).textTheme.displayLarge!.color!)),
                borderRadius: BorderRadius.circular(20)),
            margin: const EdgeInsets.only(top: 10),
            child: ListTile(
             
              minLeadingWidth: 2,
              leading: const Icon(
                Icons.location_on,
                size: 18,
                color: AppTheme.grey,
              ),
              title: Text(
                snapshot.data ?? "No address available",
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
          );
        }
      },
    );
  }

  userDataListTile(IconData person, String s, BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: Border.symmetric(
              horizontal: BorderSide(
                  width: 2.0,
                  style: BorderStyle.solid,
                  color: Theme.of(context).textTheme.displayLarge!.color!)),
          borderRadius: BorderRadius.circular(20)),
      margin: const EdgeInsets.only(top: 10),
      child: ListTile(
        minLeadingWidth: 2,
        leading: Icon(
          person,
          size: 18,
          color: Theme.of(context).textTheme.displayLarge!.color!,
        ),
        title: Text(s, style: Theme.of(context).textTheme.bodyLarge),
      ),
    );
  }
}
