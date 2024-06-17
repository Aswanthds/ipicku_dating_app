import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:ipicku_dating_app/data/functions/profile_functions.dart';
import 'package:ipicku_dating_app/data/model/user.dart';
import 'package:ipicku_dating_app/data/repositories/user_repositories.dart';
import 'package:ipicku_dating_app/domain/firebase_data/firebase_data_bloc.dart';
import 'package:ipicku_dating_app/presentation/chatpage/widget/custom_cropper.dart';
import 'package:ipicku_dating_app/presentation/profile/widgets/profile_card_text.dart';
import 'package:ipicku_dating_app/presentation/profile/widgets/userphoto_profile_list_widget.dart';
import 'package:ipicku_dating_app/presentation/ui_utils/colors.dart';
import 'package:ipicku_dating_app/presentation/profile/widgets/delete_account.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

class UpdateProfileScreen extends StatelessWidget {
  final Map<String, dynamic> userData;
  final UserRepository userRepository;

  const UpdateProfileScreen(
      {Key? key, required this.userData, required this.userRepository})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextEditingController nameController = TextEditingController();

    final TextEditingController bioController = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        leading: IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(LineAwesomeIcons.angle_left_solid)),
        title: Text("EditProfile",
            style: Theme.of(context).textTheme.headlineMedium),
      ),
      body: SingleChildScrollView(
        child: BlocConsumer<FirebaseDataBloc, FirebaseDataState>(
          listener: (context, state) {
            if (state is FirebaseDataInitial) {
              BlocProvider.of<FirebaseDataBloc>(context)
                  .add(FirebaseDataLoadedEvent());
            }
            if (state is FirebaseDataLoaded) {}
          },
          builder: (context, state) {
            if (state is FirebaseDataLoaded) {
              return Container(
                padding: const EdgeInsets.all(12),
                child: Column(
                  children: [
                    // -- IMAGE with ICON
                    Center(
                      child: Stack(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(15),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  height: 120,
                                  width: 120,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(100),
                                    image: DecorationImage(
                                      image: CachedNetworkImageProvider(
                                          state.data?["photoUrl"]),
                                      fit: BoxFit.fitWidth,
                                    ),
                                  ),
                                )

                                //  const SizedBox(width: 8.0),
                              ],
                            ),
                          ),
                          Positioned(
                            bottom: 10,
                            right: 10,
                            child: IconButton.filled(
                                onPressed: () async {
                                  final pickedImage =
                                      await ProfileFunctions.pickImage();
                                  if (pickedImage != null) {
                                    // BlocProvider.of<FirebaseDataBloc>(context)
                                    //     .add(FirebaseProfilePhotochanged(pickedImage));
                                    Navigator.of(context)
                                        .push(MaterialPageRoute(
                                      builder: (context) => CustomCropperPage(
                                        path: pickedImage,
                                        title: 'Profile picture',
                                      ),
                                    ));
                                  }
                                  // ProfileFunctions.pickAndCropImage(context);
                                },
                                icon: const Icon(Icons.camera_alt)),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(height: 50),
                    //  DialogManager.showEditDialog(
                    //                         context: context,
                    //                         isEditable: isEditable,
                    //                         controller: controller,
                    //                         field: field,
                    //                         heading: heading,
                    //                         value: value,
                    //                       );
                    // -- Form Fields
                    Form(
                      child: Column(
                        children: [
                          TextFormField(
                            controller: nameController,
                            autocorrect: true,
                            maxLines: 1,
                            onEditingComplete: () {
                              BlocProvider.of<FirebaseDataBloc>(context)
                                  .add(UpdateUserFieldEvent(
                                "name",
                                nameController.text,
                              ));
                            },
                            style: Theme.of(context).textTheme.displaySmall,
                            decoration: InputDecoration(
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15),
                                    borderSide: BorderSide(
                                        color: Theme.of(context)
                                                .textTheme
                                                .headlineMedium
                                                ?.color ??
                                            Colors.black)),
                                hintText: state.data?['name'],
                                hintStyle: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(fontSize: 15),
                                prefixIcon: Icon(
                                  LineAwesomeIcons.user,
                                  color: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.color,
                                )),
                          ),
                          const SizedBox(height: 20),
                          // TextFormField(
                          //   autocorrect: true,
                          //   maxLines: 1,
                          //   style: Theme.of(context).textTheme.displaySmall,
                          //   decoration: InputDecoration(
                          //       label: Text("${userData['name']}"),
                          //       prefixIcon: const Icon(LineAwesomeIcons.envelope)),
                          // ),
                          const SizedBox(height: 20),
                          TextFormField(
                            autocorrect: true,
                            readOnly: true,
                            maxLines: 1,
                            style: Theme.of(context).textTheme.headlineSmall,
                            onTap: () async {
                              final date = await showDatePicker(
                                  context: context,
                                  firstDate: DateTime(1990),
                                  confirmText: "Save",
                                  lastDate: DateTime.now());
                              if (date != null) {
                                BlocProvider.of<FirebaseDataBloc>(context)
                                    .add(UpdateUserFieldEvent(
                                  "dob",
                                  date,
                                ));
                                BlocProvider.of<FirebaseDataBloc>(context).add(
                                  UpdateUserFieldEvent(
                                    'age',
                                    ProfileFunctions.calculateAge(date),
                                  ),
                                );
                              }
                            },
                            decoration: InputDecoration(
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15),
                                    borderSide: BorderSide(
                                        color: Theme.of(context)
                                                .textTheme
                                                .headlineMedium
                                                ?.color ??
                                            Colors.black)),
                                hintText: DateFormat('dd-MM-yyyy').format(
                                    (state.data?['dob'] as Timestamp).toDate()),
                                hintStyle: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(fontSize: 15),
                                prefixIcon: Icon(
                                  LineAwesomeIcons.calendar_alt,
                                  color: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.color,
                                )),
                          ),
                          const SizedBox(height: 20),
                          TextFormField(
                            autocorrect: true,
                            controller: bioController,
                            style: Theme.of(context).textTheme.headlineSmall,
                            maxLines: 5,
                            maxLength: 150,
                            onEditingComplete: () {
                              BlocProvider.of<FirebaseDataBloc>(context).add(
                                UpdateUserFieldEvent(
                                  'bio',
                                  bioController.text,
                                ),
                              );
                            },
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide: BorderSide(
                                      color: Theme.of(context)
                                              .textTheme
                                              .headlineMedium
                                              ?.color ??
                                          Colors.black)),
                              hintText: "bio",
                              prefixIcon: Icon(
                                LineAwesomeIcons.book_open_solid,
                                color: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.color,
                              ),
                            ),
                          ),

                          UserPhotosOwnProfile(
                              user: UserModel.fromJson(userData)),
                          // -- Form Submit Button
                          // SizedBox(
                          //   width: double.infinity,
                          //   child: ElevatedButton(
                          //     onPressed: () {},
                          //     // Get.to(() => const UpdateProfileScreen()),
                          //     style: ElevatedButton.styleFrom(
                          //         backgroundColor: AppTheme.redAccent,
                          //         side: BorderSide.none,
                          //         shape: const StadiumBorder()),
                          //     child: const Text("EditProfile",
                          //         style: TextStyle(color: Colors.white)),
                          //   ),
                          // ),
                          const SizedBox(height: 10),

                          // -- Created Date and Delete Button
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text.rich(
                                TextSpan(
                                  text: "Joined on",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Theme.of(context)
                                        .textTheme
                                        .bodyLarge
                                        ?.color,
                                  ),
                                  children: [
                                    TextSpan(
                                        text:
                                            " ${DateFormat('dd-MM-yyyy').format((userData['created'] as Timestamp).toDate())}",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Theme.of(context)
                                                .textTheme
                                                .bodySmall
                                                ?.color,
                                            fontSize: 12))
                                  ],
                                ),
                              ),
                              DeleteAccountWidget(
                                userRepository: userRepository,
                              ),
                              // ElevatedButton(
                              //   onPressed: () {},
                              //   style: ElevatedButton.styleFrom(
                              //       backgroundColor:
                              //           Colors.redAccent.withOpacity(0.1),
                              //       elevation: 0,
                              //       foregroundColor: Colors.red,
                              //       shape: const StadiumBorder(),
                              //       side: BorderSide.none),
                              //   child: const Text("Delete your Account"),
                              // ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }
            if (state is FirebaseDataLoading) {
              return CircularProgressIndicator();
            }
            return SizedBox();
          },
        ),
      ),
    );
  }
}
