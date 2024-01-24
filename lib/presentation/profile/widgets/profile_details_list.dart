import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ipicku_dating_app/constants.dart';
import 'package:ipicku_dating_app/domain/firebase_data/firebase_data_bloc.dart';

class ProfileDetailsListTile extends StatelessWidget {
  final String? heading;
  final String? value;
  final bool isEditable;
  final String? field;
  final TextEditingController? controller;
  const ProfileDetailsListTile({
    super.key,
    required this.heading,
    required this.value,
    required this.isEditable,
    this.controller,
    this.field,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          heading ?? '',
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.start,
          style: const TextStyle(
            color: AppTheme.black,
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 15.0),
              child: Text(
                value ?? '',
                textAlign: TextAlign.justify,
                maxLines: (field == "bio") ? 2 : 1,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: isEditable ? AppTheme.black : Colors.black38,
                ),
              ),
            ),
            IconButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.zero),
                      title: Text('Edit $heading'),
                      content: TextFormField(
                        controller: controller,
                        autocorrect: true,
                        maxLines: (field == "bio") ? 5 : 1,
                        decoration: InputDecoration(
                            border: const OutlineInputBorder(),
                            hintText: "Enter your $heading here"),
                      ),
                      actions: <Widget>[
                        TextButton(
                          child: const Text('Cancel'),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                        TextButton(
                          child: const Text('Submit'),
                          onPressed: () {
                            BlocProvider.of<FirebaseDataBloc>(context).add(
                              UpdateUserFieldEvent(
                                field ?? '',
                                controller?.text.trim(),
                              ),
                            );
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    );
                  },
                );
              },
              icon: const Icon(
                EvaIcons.edit2,
                color: AppTheme.black,
                size: 18,
              ),
            ),
          ],
        )
      ],
    );
  }
}
