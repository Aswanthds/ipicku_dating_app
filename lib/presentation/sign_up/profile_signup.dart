// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'package:ipicku_dating_app/presentation/ui_utils/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:ipicku_dating_app/data/functions/profile_functions.dart';
import 'package:ipicku_dating_app/data/repositories/user_repositories.dart';
import 'package:ipicku_dating_app/domain/auth_bloc/authentication_bloc.dart';
import 'package:ipicku_dating_app/domain/profile_bloc/profile_bloc.dart';
import 'package:ipicku_dating_app/domain/profile_bloc/profile_state.dart';
import 'package:ipicku_dating_app/presentation/main_page.dart';
import 'package:ipicku_dating_app/presentation/sign_up/widgets/profile_form.dart';
import 'package:ipicku_dating_app/presentation/ui_utils/constants.dart';
import 'package:ipicku_dating_app/presentation/ui_utils/input_decoration.dart';

class SignupProfilePage extends StatefulWidget {
  final UserRepository userRepository;
  const SignupProfilePage({
    Key? key,
    required this.userRepository,
  }) : super(key: key);

  @override
  State<SignupProfilePage> createState() => _SignupProfilePageState();
}

class _SignupProfilePageState extends State<SignupProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  XFile? _pickedImage;
  String? _gender;
  DateTime? _selectedDate;
  final List<File?> _selectedImages = List.filled(3, null, growable: false);

  bool isPopulated() =>
      _nameController.text.isNotEmpty &&
      _gender != null &&
      _pickedImage != null &&
      _selectedImages.isNotEmpty &&
      _selectedDate != null;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return BlocListener<ProfileBloc, ProfileState>(
      listener: (context, state) {
        if (state is ProfileStateFailure) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBarManager.profileFailedSnackBar,
            );
        }

        if (state is ProfileStateLoading) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(SnackBarManager.profileLoading);
        }
        if (state is ProfileStateSuccess) {
          BlocProvider.of<AuthenticationBloc>(context).add(LoggedIn());
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(SnackBarManager.profileSuccessSnackBar);
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (context) =>
                    MainPageNav(repository: widget.userRepository),
              ),
              (route) => false);
        }
      },
      child: Scaffold(
        backgroundColor: AppTheme.kPrimary,
        appBar: AppBar(
          automaticallyImplyLeading: true,
          backgroundColor: Colors.transparent,
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: BlocBuilder<ProfileBloc, ProfileState>(
              builder: (context, state) {
                return Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        ProfilePicture(
                          onTap: () async {
                            final image = await ProfileFunctions.pickImage();
                            if (image != null) {
                              var croppedImage =
                                  await ProfileFunctions.cropProfileImage(
                                      File(image.path));
                              setState(() {
                                _pickedImage = XFile(croppedImage!.path);
                              });
                            }
                          },
                          pickedImage: _pickedImage,
                        ),
                        ProfileSignUpFormField(
                          controller: _nameController,
                          icon: Icons.person_4,
                          state: state,
                          title: 'Name',
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Enter a name";
                            } else {
                              return null;
                            }
                          },
                        ),
                        ProfileDropdownButton(
                          gender: _gender,
                          onChanged: (value) => setState(() => _gender = value),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        ProfileDatePicker(
                          onTap: () async {
                            final DateTime? pickedDate =
                                await ProfileFunctions.pickDateofBirth(context);
                            setState(() {
                              _selectedDate = pickedDate;
                              debugPrint(
                                  ProfileFunctions.calculateAge(pickedDate)
                                      .toString());
                            });
                          },
                          selectedDate: _selectedDate,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        isPopulated()
                            ? SizedBox(
                                width: size.width - 60,
                                height: 50,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(15))),
                                  onPressed: () {
                                    _onSubmitted();
                                  },
                                  child: const Text('Submit'),
                                ),
                              )
                            : SizedBox(
                                width: size.width - 60,
                                height: 50,
                                child: ElevatedButton(
                                  onPressed: () {},
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppTheme.grey,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12.0),
                                    ),
                                  ),
                                  child: const Text("Register"),
                                ),
                              ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  _onSubmitted() async {
    var location = await ProfileFunctions.getLocation();
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        backgroundColor: Colors.green, content: Text("Submitting your data")));

    Future.delayed(const Duration(seconds: 5)).then((value) {
      BlocProvider.of<ProfileBloc>(context).add(Submitted(
          age: ProfileFunctions.calculateAge(_selectedDate),
          dob: _selectedDate,
          createdNow: Timestamp.now(),
          name: _nameController.text.trim(),
          gender: _gender,
          location: location,
          photo: File(_pickedImage?.path ?? '')));
    });
  }
}

class ProfilePicture extends StatelessWidget {
  final XFile? pickedImage;
  final VoidCallback onTap;

  const ProfilePicture({
    Key? key,
    required this.pickedImage,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: CircleAvatar(
        radius: 50,
        backgroundColor: AppTheme.white,
        backgroundImage:
            pickedImage != null ? FileImage(File(pickedImage!.path)) : null,
        child: pickedImage == null
            ? const Icon(
                Icons.add_a_photo,
                color: AppTheme.black,
              )
            : null,
      ),
    );
  }
}

class ProfileDropdownButton extends StatefulWidget {
  final String? gender;
  final ValueChanged<String?> onChanged;

  const ProfileDropdownButton({
    Key? key,
    required this.gender,
    required this.onChanged,
  }) : super(key: key);

  @override
  State<ProfileDropdownButton> createState() => _ProfileDropdownButtonState();
}

class _ProfileDropdownButtonState extends State<ProfileDropdownButton> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: DropdownButtonFormField<String>(
        style: const TextStyle(color: AppTheme.white),
        dropdownColor: AppTheme.grey,
        value: widget.gender,
        decoration: InputDecorationManager.inputDecoration,
        onChanged: widget.onChanged,
        items: ['Male', 'Female']
            .map((gender) => DropdownMenuItem(
                value: gender,
                child: Text(
                  gender,
                )))
            .toList(),
      ),
    );
  }
}

class ProfileDatePicker extends StatefulWidget {
  final DateTime? selectedDate;
  final void Function()? onTap;
  const ProfileDatePicker({
    Key? key,
    required this.selectedDate,
    required this.onTap,
  }) : super(key: key);

  @override
  State<ProfileDatePicker> createState() => _ProfileDatePickerState();
}

class _ProfileDatePickerState extends State<ProfileDatePicker> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: widget.onTap,
      title: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          border: Border.all(
            color: AppTheme.white,
            style: BorderStyle.solid,
          ),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Text(
          widget.selectedDate != null
              ? DateFormat('dd-MM-yyyy').format(widget.selectedDate!)
              : '<Not Set>',
          style: const TextStyle(
            color: AppTheme.white,
          ),
        ),
      ),
      trailing: const Icon(
        EvaIcons.calendarOutline,
        color: AppTheme.white,
      ),
    );
  }
}

class ImageGrid extends StatefulWidget {
  final List<File?> selectedImages;

  const ImageGrid({
    required this.selectedImages,
    Key? key,
  }) : super(key: key);

  @override
  State<ImageGrid> createState() => _ImageGridState();
}

class _ImageGridState extends State<ImageGrid> {
  final ImagePicker imagePicker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(
        widget.selectedImages.length,
        (index) => Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: GestureDetector(
              onTap: () async {
                final image = await imagePicker.pickImage(
                  source: ImageSource.gallery,
                );
                if (image != null) {
                  setState(() {
                    widget.selectedImages[index] = File(image.path);
                  });
                }
                debugPrint(image!.name);
              },
              child: Container(
                  height: 120,
                  width: 72,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: AppTheme.grey,
                      image: widget.selectedImages[index] != null
                          ? DecorationImage(
                              image: FileImage(
                                widget.selectedImages[index]!,
                              ),
                              fit: BoxFit.cover,
                            )
                          : const DecorationImage(
                              image: AssetImage("assets/images/logo_dark.png"),
                              opacity: 0.4,
                              fit: BoxFit.scaleDown)))),
        ),
      ),
    );
  }
}

class ImageUploadDialog extends StatelessWidget {
  final List<File?> selectedImages;

  const ImageUploadDialog({
    required this.selectedImages,
    Key? key,
  }) : super(key: key);

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
            ImageGrid(selectedImages: selectedImages),
            const SizedBox(height: 16.0),
            Align(
              alignment: Alignment.bottomRight,
              child: ElevatedButton(
                onPressed: () {
                  // BlocProvider.of<ProfileBloc>(context).add(
                  //   PhotosChanged(photos: selectedImages),
                  // );
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
