import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ipicku_dating_app/data/functions/profile_functions.dart';
import 'package:ipicku_dating_app/domain/bloc/firebase_data_bloc.dart';
import 'package:ipicku_dating_app/presentation/profile/widgets/profile_card_text.dart';

class ProfileCardWidget extends StatelessWidget {
  final String path, age, name, id;
  const ProfileCardWidget(
      {Key? key,
      required this.path,
      required this.age,
      required this.name,
      required this.id})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FirebaseDataBloc, FirebaseDataState>(
      builder: (context, state) {
        return Card(
          elevation: 12.0,
          child: Container(
            width: 100,
            height: 200,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.orangeAccent.shade100,
                border: Border.all(
                  style: BorderStyle.solid,
                  color: Colors.black12,
                  width: 1.5,
                )),
            child: ClipPath(
              clipper: ClipPathClass(),
              child: Stack(
                children: [
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    color: Colors.yellow.shade300,
                    child: Padding(
                      padding: const EdgeInsets.all(15),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            state is FirebaseDataLoaded
                                ? Container(
                                    height: 120,
                                    width: 120,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      image: DecorationImage(
                                        image: NetworkImage(path),
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                  )
                                : Container(
                                    height: 100,
                                    width: 100,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(100),
                                      color: Colors.black,
                                    ),
                                  ),
                            const SizedBox(width: 8.0),
                            ProfileDetails(
                              age: age,
                              name: name,
                              uid: id,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 50,
                    left: 0,
                    child: IconButton.filled(
                        onPressed: () async {
                          final pickedImage =
                              await ProfileFunctions.pickImage();
                          if (pickedImage != null) {
                            BlocProvider.of<FirebaseDataBloc>(context)
                                .add(FirebaseProfilePhotochanged(pickedImage));
                          }
                        },
                        icon: Icon(Icons.camera_alt)),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class ClipPathClass extends CustomClipper<Path> {
  var radius = 10.0;
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(3, size.height);
    path.quadraticBezierTo(
        size.width / 3, size.height - 40, size.width / 2, size.height - 20);
    path.quadraticBezierTo(
        3 / 4 * size.width, size.height, size.width, size.height - 30);
    path.lineTo(size.width, 0);
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
