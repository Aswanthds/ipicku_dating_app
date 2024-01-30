import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ipicku_dating_app/constants.dart';
import 'package:ipicku_dating_app/data/repositories/user_repositories.dart';
import 'package:ipicku_dating_app/domain/bloc/matches_data_bloc.dart';

class ActionsButton extends StatelessWidget {
  final UserRepository repository;
  final String id;
  final void Function() onActionPressed;
  const ActionsButton({
    super.key,
    required this.repository,
    required this.id,
    required this.onActionPressed,
  });

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 35,
      backgroundColor: AppTheme.white,
      child: IconButton(
        onPressed: () async {
          //ProfileFunctions().showSelectionAnimation(context, Offset.zero);
          BlocProvider.of<MatchesDataBloc>(context)
              .add(AddUserAsAPick(selectedUserId: id));

          onActionPressed();
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
