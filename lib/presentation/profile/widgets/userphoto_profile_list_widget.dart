import 'dart:io';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ipicku_dating_app/presentation/ui_utils/colors.dart';
import 'package:ipicku_dating_app/data/functions/profile_functions.dart';
import 'package:ipicku_dating_app/data/model/user.dart';
import 'package:ipicku_dating_app/domain/firebase_data/firebase_data_bloc.dart';
import 'package:ipicku_dating_app/presentation/profile/user_profile/image_preview.dart';

class UserPhotosOwnProfile extends StatefulWidget {
  final UserModel? user;

  const UserPhotosOwnProfile({
    Key? key,
    this.user,
  }) : super(key: key);

  @override
  State<UserPhotosOwnProfile> createState() => _UserPhotosOwnProfileState();
}

class _UserPhotosOwnProfileState extends State<UserPhotosOwnProfile> {
  final List<File?> _selectedImages = List.generate(3, (index) => null);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
          child: Text(
            "Photos",
            textAlign: TextAlign.start,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: AppTheme.black,
              fontSize: 18,
            ),
          ),
        ),
        Row(
          children: List<Widget>.generate(
            3,
            (index) => InkWell(
              onTap: () {
                if (widget.user?.userPhotos != null &&
                    widget.user!.userPhotos!.isNotEmpty) {
                  if (index < widget.user!.userPhotos!.length) {
                    _selectedImages.isNotEmpty
                        ? Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => ImagePreviewPage(
                              imageUrl: widget.user?.userPhotos?[index],
                            ),
                          ))
                        : null;
                  } else {
                    _onImageSelection(index);
                  }
                } else {
                  _onImageSelection(index);
                }
              },
              onLongPress: () {
                if (widget.user?.userPhotos != null &&
                    widget.user!.userPhotos!.isNotEmpty &&
                    index < widget.user!.userPhotos!.length) {
                  _onImageSelection(index);
                }
              },
              child: Card(
                elevation: 5.0,
                margin: const EdgeInsets.all(10),
                child: Container(
                  height: 120,
                  width: 80,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: widget.user?.userPhotos != null &&
                            widget.user!.userPhotos!.isNotEmpty &&
                            index < widget.user!.userPhotos!.length
                        ? null
                        : Colors.black38,
                    image: widget.user?.userPhotos != null &&
                            widget.user!.userPhotos!.isNotEmpty &&
                            index < widget.user!.userPhotos!.length
                        ? DecorationImage(
                            image: NetworkImage(
                              widget.user?.userPhotos?[index],
                            ),
                            fit: BoxFit.cover,
                          )
                        : null,
                  ),
                  child: widget.user?.userPhotos != null &&
                          widget.user!.userPhotos!.isNotEmpty &&
                          index < widget.user!.userPhotos!.length
                      ? null
                      : const Center(
                          child: Icon(
                            Icons.add_a_photo_outlined,
                            color: AppTheme.white,
                          ),
                        ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _onImageSelection(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: const Text("Select an Image"),
        backgroundColor: AppTheme.white,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text(
              "Cancel",
              style: TextStyle(color: AppTheme.red),
            ),
          ),
          TextButton.icon(
            onPressed: () async {
              final image = await ProfileFunctions.pickImage();
              final croppedImage =
                  await ProfileFunctions.cropImage(File(image!.path));

              setState(() {
                _selectedImages[index] = File(croppedImage!.path);
              });

              BlocProvider.of<FirebaseDataBloc>(context).add(
                FirebaseDataPhotoChanged(
                  XFile(croppedImage!.path),
                  index,
                ),
              );

              Navigator.of(context).pop();
            },
            icon: const Icon(
              EvaIcons.arrowRight,
              color: AppTheme.green,
            ),
            label: const Text(
              "Continue",
              style: TextStyle(
                color: AppTheme.green,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
