import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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
          userDataListTile(
              Icons.calendar_month_rounded,
              DateFormat('dd - MMM - yyy')
                  .format((data['dob'] as Timestamp).toDate()),
              context),
          userDataListTile(Icons.person, "${data['gender']}", context),
          (data['location'] != null)
              ? userDataListTile(Icons.map, data['location'], context)
              : const SizedBox()
        ],
      ),
    );
  }

  userDataListTile(IconData person, String s, BuildContext context) {
    return Container(
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
