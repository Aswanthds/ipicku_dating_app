// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ipicku_dating_app/presentation/ui_utils/colors.dart';
import 'package:ipicku_dating_app/data/model/user.dart';
import 'package:ipicku_dating_app/domain/firebase_data/firebase_data_bloc.dart';

class InterestDataWidget extends StatefulWidget {
  const InterestDataWidget({
    Key? key,
    required this.user,
    required this.interestController,
  }) : super(key: key);

  final UserModel? user;
  final TextEditingController interestController;

  @override
  State<InterestDataWidget> createState() => _InterestDataWidgetState();
}

class _InterestDataWidgetState extends State<InterestDataWidget> {
  List<String> selectedInterests = [];

  @override
  Widget build(BuildContext context) {
    List? userInterests = widget.user?.interests;
    final List<String> predefinedInterests = [
      'Travel',
      'Fitness',
      'Photography',
      'Technology',
      'Cooking',
      'Music',
      'Reading',
      'Gaming',
      'Art',
      'Sports'
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Interests",
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.start,
              style: TextStyle(
                color: AppTheme.black,
              ),
            ),
            IconButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.zero,
                      ),
                      title: const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "Edit Interests",
                            style: TextStyle(
                              fontSize: 21,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "Use ' , ' for more than one interest",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.grey,
                            ),
                          ),
                        ],
                      ),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Wrap(
                            children: List<Widget>.generate(
                              predefinedInterests.length,
                              (index) => FilterChip(
                                label: Text(predefinedInterests[index]),
                                selected: userInterests?.contains(
                                            predefinedInterests[index]) ==
                                        true ||
                                    selectedInterests
                                        .contains(predefinedInterests[index]),
                                onSelected: (selected) {
                                  setState(() {
                                    if (selected) {
                                      if (selectedInterests.length < 3) {
                                        selectedInterests
                                            .add(predefinedInterests[index]);
                                      }
                                    } else {
                                      selectedInterests
                                          .remove(predefinedInterests[index]);
                                    }
                                  });
                                },
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: widget.interestController,
                            autocorrect: true,
                            decoration: const InputDecoration(
                              hintText: "Enter your interests here",
                            ),
                            onEditingComplete: () {
                              selectedInterests.addAll(
                                  widget.interestController.text.split(','));
                            },
                          ),
                        ],
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
                              FirebaseAddData('Interests', selectedInterests),
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
                Icons.edit,
                color: AppTheme.black,
                size: 18,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Wrap(
          children: (userInterests?.isNotEmpty ?? false)
              ? userInterests!
                  .map(
                    (interest) => FittedBox(
                      fit: BoxFit.contain,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                        child: Chip(
                          padding: const EdgeInsets.all(5.0),
                          label: Center(
                            child: Text(interest),
                          ),
                        ),
                      ),
                    ),
                  )
                  .toList()
              : const [
                  SizedBox()
                ], // Display an empty SizedBox if userInterests is null or empty
        ),
      ],
    );
  }
}
