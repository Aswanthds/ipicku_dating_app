// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'package:ipicku_dating_app/presentation/homepage/welcome_page.dart';
import 'package:ipicku_dating_app/presentation/ui_utils/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:ipicku_dating_app/data/functions/profile_functions.dart';
import 'package:ipicku_dating_app/data/repositories/user_repositories.dart';
import 'package:ipicku_dating_app/domain/auth_bloc/authentication_bloc.dart';
import 'package:ipicku_dating_app/domain/profile_bloc/profile_bloc.dart';
import 'package:ipicku_dating_app/domain/profile_bloc/profile_state.dart';
import 'package:ipicku_dating_app/presentation/sign_up/widgets/profile_form.dart';
import 'package:ipicku_dating_app/presentation/ui_utils/constants.dart';
import 'package:ipicku_dating_app/presentation/ui_utils/dialog_manager.dart';
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
  int age = 0;
  DateTime? _selectedDate;

  bool isPopulated() =>
      _nameController.text.isNotEmpty &&
      _gender != null &&
      _pickedImage != null &&
      age >= 18 &&
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
                    WelcomePage(repository: widget.userRepository),
              ),
              (route) => false);
        }
      },
      child: Scaffold(
        backgroundColor: AppTheme.black,
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
                              // var croppedImage =
                              //     await ProfileFunctions.cropProfileImage(
                              //         File(image.path));
                              setState(() {
                                _pickedImage = image;
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
                              age = ProfileFunctions.calculateAge(pickedDate);
                            });
                          },
                          selectedDate: _selectedDate,
                        ),
                        const SizedBox(
                          height: 50,
                        ),
                        SizedBox(
                          width: size.width - 60,
                          height: 50,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    AppTheme.redAccent.withOpacity(0.95),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10))),
                            onPressed: () {
                              _onSubmitted();
                            },
                            child: const Text(
                              'Complete Profile',
                              style: TextStyle(
                                color: AppTheme.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        FutureBuilder(
                            future: widget.userRepository.getUserEmail(),
                            builder: (context, snapshot) {
                              return Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    snapshot.data ?? '',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall
                                        ?.copyWith(color: AppTheme.white),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      DialogManager.showLogoutDialog(
                                          context, widget.userRepository);
                                    },
                                    child: Text(
                                      "Logout ? ",
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelLarge
                                          ?.copyWith(
                                              color: AppTheme.red,
                                              fontWeight: FontWeight.bold),
                                    ),
                                  )
                                ],
                              );
                            }),
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
    if (_formKey.currentState!.validate() && isPopulated()) {
      var location = await ProfileFunctions.getLocation();
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          backgroundColor: Colors.green,
          content: Text("Submitting your data")));
      BlocProvider.of<ProfileBloc>(context).add(Submitted(
          age: ProfileFunctions.calculateAge(_selectedDate),
          dob: _selectedDate,
          createdNow: Timestamp.now(),
          name: _nameController.text.trim(),
          gender: _gender,
          location: location,
          photo: File(_pickedImage?.path ?? '')));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.all(10),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          content: Text("Complete the details ")));
    }
    if (_pickedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.all(10),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          content: Text("Profile picture is required")));
    }
    if (age < 18) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.all(10),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          content: Text("Age should be greater than 18")));
    }
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
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100),
            gradient: LinearGradient(colors: [
              AppTheme.pinkAccent,
              AppTheme.red,
            ])),
        child: Container(
          width: 120,
          height: 120,
          padding: const EdgeInsets.all(15),
          margin: EdgeInsets.all(2.0),
          decoration: BoxDecoration(
            color: AppTheme.white,
            borderRadius: BorderRadius.circular(100),
            image: pickedImage != null
                ? DecorationImage(
                    image: FileImage(File(pickedImage!.path)),
                    fit: BoxFit.cover)
                : null,
          ),
          child: pickedImage == null
              ? const Icon(
                  Icons.add_a_photo,
                  color: AppTheme.black,
                )
              : null,
        ),
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
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            gradient: const LinearGradient(colors: [
              AppTheme.pinkAccent,
              AppTheme.red,
            ])),
        child: Container(
          margin: const EdgeInsets.all(2.0),
          padding: const EdgeInsets.only(left: 5.0),
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(15)),
          child: DropdownButtonFormField<String>(
            style: const TextStyle(color: AppTheme.black),
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
        ),
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
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        gradient: const LinearGradient(
          colors: [
            AppTheme.pinkAccent,
            AppTheme.red,
          ],
        ),
      ),
      child: Container(
        margin: const EdgeInsets.all(2.0),
        decoration: BoxDecoration(
          color: AppTheme.white,
          borderRadius: BorderRadius.circular(15),
        ),
        child: ListTile(
          onTap: widget.onTap,
          contentPadding: EdgeInsets.zero,
          title: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              widget.selectedDate != null
                  ? DateFormat('dd-MM-yyyy').format(widget.selectedDate!)
                  : 'D.O.B',
              style: const TextStyle(
                color: AppTheme.black,
              ),
            ),
          ),
          trailing: const Icon(
            Icons.calendar_month_rounded,
            color: AppTheme.black,
          ),
        ),
      ),
    );
  }
}
