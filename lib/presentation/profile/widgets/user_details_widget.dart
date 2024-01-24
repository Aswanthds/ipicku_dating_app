// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'package:ipicku_dating_app/constants.dart';
import 'package:ipicku_dating_app/data/model/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ipicku_dating_app/domain/firebase_data/firebase_data_bloc.dart';
import 'package:ipicku_dating_app/presentation/profile/user_profile/image_preview.dart';
import 'package:ipicku_dating_app/presentation/profile/widgets/iterests-data.dart';
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
    final TextEditingController interestController = TextEditingController();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10),
        const Text(
          'User Details',
          style: TextStyle(
            color: AppTheme.black,
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
                color: AppTheme.black,
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
                  color: AppTheme.black,
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
        InterestDataWidget(user: user, interestController: interestController),
        UserPhotosOwnProfile(user: user),
      ],
    );
  }
}

// class InterestDataWidget extends StatelessWidget {
//   const InterestDataWidget({
//     super.key,
//     required this.user,
//     required this.interestController,
//   });

//   final UserModel? user;
//   final TextEditingController interestController;

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         const Text(
//           "Interests",
//           overflow: TextOverflow.ellipsis,
//           textAlign: TextAlign.start,
//           style: TextStyle(
//             color: AppTheme.black,
//           ),
//         ),
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             BlocBuilder<FirebaseDataBloc, FirebaseDataState>(
//               builder: (context, state) {
//                 if (state is FirebaseDataLoaded) {
//                   Padding(
//                       padding: const EdgeInsets.only(left: 8.0, right: 15.0),
//                       child: Wrap(
//                         children: List<Widget>.generate(
//                             3,
//                             (index) => FittedBox(
//                                   fit: BoxFit.contain,
//                                   child: Container(
//                                     width: 50,
//                                     decoration: BoxDecoration(
//                                         color: AppTheme.grey,
//                                         borderRadius:
//                                             BorderRadius.circular(10)),
//                                     padding: const EdgeInsets.all(5.0),
//                                     margin: const EdgeInsets.only(
//                                       left: 5,
//                                       right: 5,
//                                     ),
//                                     child: Center(
//                                         child: user?.interests?[index] != null
//                                             ? Text(
//                                                 user?.interests?[index] ?? '')
//                                             : const Text('')),
//                                   ),
//                                 )),
//                       ));
//                 }
//                 return const SizedBox();
//               },
//             ),
//             IconButton(
//               onPressed: () {
//                 showDialog(
//                   context: context,
//                   builder: (BuildContext context) {
//                     return AlertDialog(
//                       shape: const RoundedRectangleBorder(
//                           borderRadius: BorderRadius.zero),
//                       title: const Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             "Edit Interests",
//                             style: TextStyle(
//                                 fontSize: 21, fontWeight: FontWeight.bold),
//                           ),
//                           Text(
//                             "use ' , ' for more than one interests",
//                             style: TextStyle(
//                                 fontSize: 16,
//                                 fontWeight: FontWeight.bold,
//                                 color: AppTheme.grey),
//                           ),
//                         ],
//                       ),
//                       content: TextFormField(
//                         controller: interestController,
//                         autocorrect: true,
//                         decoration: const InputDecoration(
//                             hintText: "Enter your interests here"),
//                       ),
//                       actions: <Widget>[
//                         TextButton(
//                           child: const Text('Cancel'),
//                           onPressed: () {
//                             Navigator.of(context).pop();
//                           },
//                         ),
//                         TextButton(
//                           child: const Text('Submit'),
//                           onPressed: () {
//                             BlocProvider.of<FirebaseDataBloc>(context).add(
//                               FirebaseAddData(
//                                 'Interests',
//                                 interestController.text.trim().split(','),
//                               ),
//                             );
//                             Navigator.of(context).pop();
//                           },
//                         ),
//                       ],
//                     );
//                   },
//                 );
//               },
//               icon: const Icon(
//                 EvaIcons.edit2,
//                 color: AppTheme.black,
//                 size: 18,
//               ),
//             ),
//           ],
//         )
//       ],
//     );
//   }
// }

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
