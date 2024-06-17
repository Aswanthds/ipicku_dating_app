import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ipicku_dating_app/presentation/ui_utils/colors.dart';
import 'package:ipicku_dating_app/data/model/user.dart';
import 'package:ipicku_dating_app/domain/firebase_data/firebase_data_bloc.dart';

class ProfileGenderWidget extends StatelessWidget {
  const ProfileGenderWidget({
    super.key,
    required this.user,
  });

  final UserModel? user;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Gender',
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.start,
          style: TextStyle(
            color: AppTheme.black,
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 15.0),
              child: Text(
                user?.gender ?? 'None',
                textAlign: TextAlign.justify,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppTheme.black,
                ),
              ),
            ),
            IconButton(
              onPressed: () async {
                _showGenderDialog(context);
              },
              icon: const Icon(
                Icons.edit,
                color: AppTheme.black,
                size: 18,
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _showGenderDialog(BuildContext context) {
    String? selectedGender;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Select Gender ',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListTile(
                    title: Text(
                      'Male',
                      style: Theme.of(context).textTheme.displaySmall,
                    ),
                    leading: Radio<String>(
                      value: 'Male',
                      groupValue: selectedGender,
                      onChanged: (String? value) {
                        setState(() {
                          selectedGender = value;
                        });
                      },
                    ),
                  ),
                  ListTile(
                    title: Text(
                      'Female',
                      style: Theme.of(context).textTheme.displaySmall,
                    ),
                    leading: Radio<String>(
                      value: 'Female',
                      groupValue: selectedGender,
                      onChanged: (String? value) {
                        setState(() {
                          selectedGender = value;
                        });
                      },
                    ),
                  ),
                  const Text(
                      'Please refresh home after updating to get latest data')
                ],
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                BlocProvider.of<FirebaseDataBloc>(context).add(
                  UpdateUserFieldEvent(
                    'gender',
                    selectedGender,
                  ),
                );
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Submit'),
            ),
          ],
        );
      },
    );
  }
}
