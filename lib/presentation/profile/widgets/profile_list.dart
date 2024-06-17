import 'package:flutter/material.dart';

class ProfileListTile extends StatelessWidget {
  final IconData leading;
  final String text;
  final void Function() onTap;
  const ProfileListTile({
    super.key,
    required this.leading,
    required this.text,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: Icon(leading),
      title: Text(text),
      trailing: const Icon(Icons.arrow_forward_ios),
    );
  }
}

class ProfileImageWidget extends StatelessWidget {
  const ProfileImageWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 150,
        width: 105,
        margin: const EdgeInsets.only(left: 10),
        decoration: BoxDecoration(
            border: Border.all(
              style: BorderStyle.solid,
            ),
            borderRadius: BorderRadius.circular(12)),
        child: Center(
          child: IconButton(
              icon: const Icon(Icons.image), onPressed: () {}),
        ));
  }
}
