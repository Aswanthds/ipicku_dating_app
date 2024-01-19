// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'package:ipicku_dating_app/data/model/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ipicku_dating_app/domain/bloc/firebase_data_bloc.dart';
import 'package:ipicku_dating_app/presentation/profile/user_profile/image_preview.dart';
import 'package:ipicku_dating_app/presentation/profile/widgets/profile_date.dart';
import 'package:ipicku_dating_app/presentation/profile/widgets/profile_details_list.dart';

class UserDetailsList extends StatelessWidget {
  final UserModel? user;
  const UserDetailsList({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController emailController = TextEditingController();
    final TextEditingController bioController = TextEditingController();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10),
        const Text(
          'User Details',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        ProfileDetailsListTile(
          heading: 'Name',
          value: '${user?.name}',
          isEditable: true,
          controller: nameController,
          field: 'name',
        ),
        ProfileDetailsListTile(
          heading: 'Email',
          value: '${user?.email}',
          controller: emailController,
          isEditable: true,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Age',
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.start,
              style: TextStyle(
                color: Colors.black,
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.only(right: 70.0, top: 8.0, bottom: 8.0),
              child: Text(
                '${user?.age} yrs old',
                textAlign: TextAlign.justify,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
        ProfileDateWidget(user: user),

        ProfileDetailsListTile(
          heading: 'Bio',
          value: user?.bio ?? '< Not Set >',
          controller: bioController,
          isEditable: true,
          field: 'bio',
        ),

        //  context: context,

        UserPhotosOwnProfile(user: user),
      ],
    );
  }
}

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
              color: Colors.black,
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
                      : Center(
                          child: Icon(
                            Icons.add_a_photo_outlined,
                            color: Colors.white,
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
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () async {
              final image = await ImagePicker().pickImage(
                source: ImageSource.gallery,
              );

              if (image != null) {
                setState(() {
                  _selectedImages[index] = File(image.path);
                });
              }

              BlocProvider.of<FirebaseDataBloc>(context).add(
                FirebaseDataPhotoChanged(
                  image!,
                  index,
                ),
              );

              Navigator.of(context).pop();
            },
            child: const Text("Continue"),
          ),
        ],
      ),
    );
  }
}
