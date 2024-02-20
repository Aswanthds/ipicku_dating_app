import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:ipicku_dating_app/presentation/ui_utils/colors.dart';
import 'package:ipicku_dating_app/presentation/ui_utils/dialog_manager.dart';

class BioProfileEditPage extends StatelessWidget {
  final String? value;
  final TextEditingController? controller;
  const BioProfileEditPage({
    super.key,
    required this.value,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Bio',
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.start,
          style: TextStyle(
            color: AppTheme.black,
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Container(
              decoration:
                  BoxDecoration(border: Border.all(style: BorderStyle.solid)),
              width: 200,
              height: 100,
              padding: const EdgeInsets.all(8.0),
              child: Text(
                value ?? '',
                textAlign: TextAlign.start,
                maxLines: 4,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppTheme.black,
                ),
              ),
            ),
            IconButton(
              onPressed: () {
                DialogManager.showEditDialog(
                    context: context,
                    isEditable: false,
                    controller: controller,
                    field: 'bio',
                    value: value,
                    heading: 'Bio');
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
/*

  ProfileDropdownButton(
          gender: widget.user?.gender,
          onChanged: (value) => setState(() => _gender = value),
        ),
*/