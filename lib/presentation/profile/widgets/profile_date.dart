// ignore_for_file: use_build_context_synchronously

import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:ipicku_dating_app/presentation/ui_utils/colors.dart';
import 'package:ipicku_dating_app/data/functions/profile_functions.dart';
import 'package:ipicku_dating_app/data/model/user.dart';
import 'package:ipicku_dating_app/domain/firebase_data/firebase_data_bloc.dart';

class ProfileDateWidget extends StatelessWidget {
  const ProfileDateWidget({
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
          'D.O.B',
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
                (user?.dob != null)
                    ? DateFormat('dd - MMM -yyy').format(user!.dob!)
                    : 'Not available',
                textAlign: TextAlign.justify,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppTheme.black,
                ),
              ),
            ),
            IconButton(
              onPressed: () async {
                final pickedDate =
                    await ProfileFunctions.pickDateofBirth(context);
              if(pickedDate != null){
                  BlocProvider.of<FirebaseDataBloc>(context).add(
                    UpdateUserFieldEvent(
                      'dob',
                      pickedDate,
                    ),
                  );
                  BlocProvider.of<FirebaseDataBloc>(context).add(
                    UpdateUserFieldEvent(
                      'age',
                      ProfileFunctions.calculateAge(pickedDate),
                    ),
                  );
              }
              },
              icon: const Icon(
                EvaIcons.edit2,
                color: AppTheme.black,
                size: 18,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
