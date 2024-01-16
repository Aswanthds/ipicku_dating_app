import 'dart:io';

import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ipicku_dating_app/domain/profile_bloc/profile_bloc.dart';
import 'package:ipicku_dating_app/presentation/profile/widgets/profile_details_list.dart';

class UserDetailsList extends StatelessWidget {
  const UserDetailsList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
          context: context,
          heading: 'Name',
          value: 'Aswanth DS',
          isEditable: true,
        ),
        ProfileDetailsListTile(
          context: context,
          heading: 'Email',
          value: 'aswanthds2005@gmail.com',
          isEditable: true,
        ),
        ProfileDetailsListTile(
          context: context,
          heading: 'Age',
          value: '18',
          isEditable: true,
        ),
        ProfileDetailsListTile(
          context: context,
          heading: 'Date of Birth',
          value: 'June 18,2005',
          isEditable: true,
        ),
        ProfileDetailsListTile(
          context: context,
          heading: 'Region',
          value: 'Kerala',
          isEditable: true,
        ),
        ProfileDetailsListTile(
          context: context,
          heading: 'Bio',
          value: 'Looking for a partner ',
          isEditable: true,
        ),
        // ProfileDetailsListTile(
        //  context: context,
        //   heading: 'Interests',
        //   value: 'Aswanth DS',
        //   isEditable: true,
        // ),
        const UserPhotosOwnProfile(),
      ],
    );
  }
}

class UserPhotosOwnProfile extends StatefulWidget {
  const UserPhotosOwnProfile({
    super.key,
  });

  @override
  State<UserPhotosOwnProfile> createState() => _UserPhotosOwnProfileState();
}

class _UserPhotosOwnProfileState extends State<UserPhotosOwnProfile> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          "Photos",
          textAlign: TextAlign.start,
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        IconButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) => const ImageUploadDialog(),
            );
          },
          icon: const Icon(
            EvaIcons.edit2,
            color: Colors.black,
            size: 18,
          ),
        ),
      ],
    );
  }
}

class ImageUploadDialog extends StatefulWidget {
  const ImageUploadDialog({super.key});

  @override
  State<ImageUploadDialog>  createState() => _ImageUploadDialogState();
}

class _ImageUploadDialogState extends State<ImageUploadDialog> {
  final List<File?> _selectedImages = List.generate(3, (index) => null);
  final ImagePicker _imagePicker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Image Upload',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16.0),
            Row(
              children: List.generate(
                _selectedImages.length,
                (index) => Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: GestureDetector(
                    onTap: () async {
                      final image = await _imagePicker.pickImage(
                        source: ImageSource.gallery,
                      );
                      if (image != null) {
                        setState(() {
                          _selectedImages[index] = File(image.path);
                        });
                      }
                      debugPrint(image!.name);
                    },
                    child: Container(
                      height: 60,
                      width: 60,
                      color: Colors.grey[300],
                      child: _selectedImages[index] != null
                          ? Image.file(
                              _selectedImages[index]!,
                              fit: BoxFit.cover,
                            )
                          : const Icon(Icons.add),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            Align(
              alignment: Alignment.bottomRight,
              child: ElevatedButton(
                onPressed: () {
                  // Dispatch the event to update the profile with images
                  BlocProvider.of<ProfileBloc>(context).add(
                    PhotosChanged(photos: _selectedImages),
                  );
                  Navigator.of(context).pop();
                },
                child: const Text('Save'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
