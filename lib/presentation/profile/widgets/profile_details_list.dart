import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ipicku_dating_app/domain/bloc/firebase_data_bloc.dart';

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
            color: Colors.black,
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
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: isEditable ? Colors.black : Colors.black38,
                ),
              ),
            ),
            IconButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Edit $heading'),
                      content: TextFormField(
                        controller: controller,
                        autocorrect: true,
                        decoration: InputDecoration(
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
                color: Colors.black,
                size: 18,
              ),
            ),
          ],
        )
      ],
    );
  }
}
