import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:ipicku_dating_app/presentation/chatpage/widget/user_photso.dart';
import 'package:ipicku_dating_app/presentation/ui_utils/colors.dart';
import 'package:ipicku_dating_app/data/functions/profile_functions.dart';
import 'package:ipicku_dating_app/data/model/user.dart';

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
  final double _width = 80;
  final double _height = 120;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
          child: Text(
            "Photos",
            textAlign: TextAlign.start,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).textTheme.bodySmall?.color,
              fontSize: 18,
            ),
          ),
        ),
        Row(
          children: List<Widget>.generate(
            3,
            (index) => InkWell(
              onTap: () async {
                if (widget.user?.userPhotos != null &&
                    widget.user!.userPhotos!.isNotEmpty) {
                  if (index < widget.user!.userPhotos!.length) {
                    _selectedImages.isNotEmpty
                        ? showDialog(
                            context: context,
                            builder: (context) {
                              return Dialog(
                                child: Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.8,
                                  height:
                                      MediaQuery.of(context).size.height * 0.8,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: CachedNetworkImageProvider(
                                          widget.user!.userPhotos![index]),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              );
                            },
                          )
                        : null;
                  } else {
                    _imagePicking(index);
                  }
                } else {
                  _imagePicking(index);
                }
              },
              onLongPress: () async {
                if (widget.user?.userPhotos != null &&
                    widget.user!.userPhotos!.isNotEmpty &&
                    index < widget.user!.userPhotos!.length) {
                  _imagePicking(index);
                }
              },
              child: Card(
                elevation: 5.0,
                margin: const EdgeInsets.all(10),
                child: AnimatedContainer(
                  width: _width,
                  height: _height,
                  duration: Durations.extralong1,
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
                            image: CachedNetworkImageProvider(
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

  void _imagePicking(int index) async {
    final pickedImage = await ProfileFunctions.pickImage();
    if (pickedImage != null) {
      // BlocProvider.of<FirebaseDataBloc>(context)
      //     .add(FirebaseProfilePhotochanged(pickedImage));
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => CustomUsersPhotoCrop(
          path: pickedImage,
          title: 'Profile picture',
          index: index,
        ),
      ));
    }
  }
}
