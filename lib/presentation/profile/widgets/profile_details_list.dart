import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:ipicku_dating_app/presentation/ui_utils/colors.dart';
import 'package:ipicku_dating_app/presentation/ui_utils/dialog_manager.dart';

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
                maxLines: 1,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: isEditable ? AppTheme.black : Colors.black38,
                ),
              ),
            ),
            isEditable
                ? IconButton(
                    onPressed: () {
                      DialogManager.showEditDialog(
                        context: context,
                        isEditable: isEditable,
                        controller: controller,
                        field: field,
                        heading: heading,
                        value: value,
                      );
                    },
                    icon: const Icon(
                      EvaIcons.edit2,
                      color: AppTheme.black,
                      size: 18,
                    ),
                  )
                : const SizedBox(
                    width: 50,
                    height: 25,
                  )
          ],
        )
      ],
    );
  }
}
