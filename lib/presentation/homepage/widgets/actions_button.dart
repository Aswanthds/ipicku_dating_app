import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ipicku_dating_app/constants.dart';
import 'package:ipicku_dating_app/data/repositories/user_repositories.dart';
import 'package:ipicku_dating_app/domain/bloc/matching_bloc.dart';

class ActionsButton extends StatelessWidget {
  final UserRepository repository;
  final String id;
  const ActionsButton({
    super.key,
    required this.repository,
    required this.id,
  });

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 35,
      backgroundColor: AppTheme.white,
      child: IconButton(
        onPressed: () async {
          BlocProvider.of<MatchingBloc>(context).add(AcceptUserEvent(
              currentUser: await repository.getUser(), selectedUser: id));

          //Navigator.of(context).pop();
        },
        icon: const ImageIcon(
          AssetImage('assets/images/logo_light.png'),
          size: 50,
        ),
        iconSize: 50,
      ),
    );
  }
}
