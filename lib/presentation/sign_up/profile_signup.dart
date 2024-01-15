// ignore_for_file: use_build_context_synchronously, must_be_immutable

import 'dart:io';

import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:ipicku_dating_app/constants.dart';
import 'package:ipicku_dating_app/data/functions/profile_functions.dart';
import 'package:ipicku_dating_app/data/repositories/user_repositories.dart';
import 'package:ipicku_dating_app/domain/auth_bloc/authentication_bloc.dart';
import 'package:ipicku_dating_app/domain/profile_bloc/profile_bloc.dart';
import 'package:ipicku_dating_app/domain/profile_bloc/profile_state.dart';
import 'package:ipicku_dating_app/presentation/main_page.dart';
import 'package:ipicku_dating_app/presentation/sign_up/widgets/profile_form.dart';

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
  int? _calculatedAge;

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedImage =
        await picker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      setState(() {
        _pickedImage = pickedImage;
      });
    }
    debugPrint(_pickedImage!.path);
  }

  void _calculateAge() {
    if (_selectedDate != null) {
      final today = DateTime.now();
      var age = today.year - _selectedDate!.year;
      final monthDiff = today.month - _selectedDate!.month;

      if (monthDiff < 0 || (monthDiff == 0 && today.day < _selectedDate!.day)) {
        age--;
      }

      setState(() {
        _calculatedAge = age;
      });
    }
    debugPrint(_calculatedAge != null
        ? 'Age: $_calculatedAge'
        : 'Select your date of birth');
  }

  @override
  void initState() {
   // _nameController.addListener(_onNameChanged);

    super.initState();
  }

  bool isPopulated() =>
      _nameController.text.isNotEmpty &&
      _gender != null &&
      _pickedImage != null &&
      _selectedDate != null;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return BlocListener<ProfileBloc, ProfileState>(
      listener: (context, state) {
        if (state.isFailure) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              profilefailedSnackBar,
            );
        }

        if (state.isSubmitting) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(profileSucessSnackBar);
        }
        if (state.isSuccess) {
          BlocProvider.of<AuthenticationBloc>(context).add(LoggedIn());
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (context) =>
                    MainPageNav(repository: widget.userRepository),
              ),
              (route) => false);
        }
      },
      child: Scaffold(
        backgroundColor: kPrimary,
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
                        // Profile picture
                        GestureDetector(
                          onTap: _pickImage,
                          child: CircleAvatar(
                            radius: 50,
                            backgroundImage: _pickedImage != null
                                ? FileImage(File(_pickedImage!.path))
                                : null,
                            child: _pickedImage == null
                                ? const Icon(Icons.add_a_photo)
                                : null,
                          ),
                        ),
                        // TextFormFields for name, age, etc.
                        ProfileSignUpFormField(
                          controller: _nameController,
                          icon: Icons.person_4,
                          state: state,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 10,
                          ),
                          child: DropdownButtonFormField<String>(
                            style: const TextStyle(color: Colors.white),
                            dropdownColor: Colors.grey,
                            value: _gender,
                            decoration: inputDecoration,
                            // onChanged: (value){},
                            onChanged: (value) =>
                                setState(() => _gender = value),
                            items: [
                              'Male',
                              'Female',
                            ]
                                .map((gender) => DropdownMenuItem(
                                    value: gender,
                                    child: Text(
                                      gender,
                                    )))
                                .toList(),
                          ),
                        ),
                        ListTile(
                            onTap: () async {
                              final DateTime? pickedDate = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now()
                                    .subtract(const Duration(days: 365 * 18)), 
                                lastDate: DateTime.now().subtract(
                                    const Duration(
                                        days: 365 * 18)), // 18 years ago
                                firstDate: DateTime(
                                    1900), // Set to a very high value to effectively have no upper limit
                              );

                              if (pickedDate != null) {
                                setState(() {
                                  _selectedDate = pickedDate;
                                  _calculateAge(); // Calculate age when date is selected
                                });
                              }
                            },
                            title: Container(
                              padding: const EdgeInsets.all(15),
                              decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.white,
                                    style: BorderStyle.solid,
                                  ),
                                  borderRadius: BorderRadius.circular(15)),
                              child: Text(
                                _selectedDate != null
                                    ? DateFormat('dd-MM-yyyy')
                                        .format(_selectedDate!)
                                    : '<Not Set>',
                                style: const TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            trailing: const Icon(
                              EvaIcons.calendarOutline,
                              color: Colors.white,
                            )),
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
                                  onPressed: _onSubmitted,
                                  child: const Text('Submit'),
                                ),
                              )
                            : SizedBox(
                                width: size.width - 60,
                                height: 50,
                                child: ElevatedButton(
                                  onPressed: () {},
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.grey,
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

    BlocProvider.of<ProfileBloc>(context).add(Submitted(
        age: ProfileFunctions.calculateAge(_selectedDate),
        createdNow: DateTime.now(),
        name: _nameController.text.trim(),
        gender: _gender,
        location: location,
        photo: File(_pickedImage?.path ?? '')));
  }

  // void _onNameChanged() {
  //   BlocProvider.of<ProfileBloc>(context)
  //     ..add(NameChanged(_nameController.text.trim()))
  //     ..add(PhotoChanged(File(_pickedImage?.path ?? '')))
  //     ..add(AgeChanged(_selectedDate))
  //     ..add(GenderChanged(_gender));
  // }
}
