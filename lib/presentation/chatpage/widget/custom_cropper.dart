import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:custom_image_crop/custom_image_crop.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ipicku_dating_app/domain/firebase_data/firebase_data_bloc.dart';

class CustomCropperPage extends StatefulWidget {
  final String title;
  final XFile path;

  const CustomCropperPage({
    required this.title,
    Key? key,
    required this.path,
  }) : super(key: key);

  @override
  _CustomCropperPageState createState() => _CustomCropperPageState();
}

class _CustomCropperPageState extends State<CustomCropperPage> {
  late CustomImageCropController controller;

  @override
  void initState() {
    super.initState();
    controller = CustomImageCropController();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        children: [
          Expanded(
            child: CustomImageCrop(
                cropController: controller,
                image: FileImage(File(widget.path
                    .path)) // Any Imageprovider will work, try with a NetworkImage for example...
                ),
          ),
          Row(
            children: [
              IconButton(
                  icon: const Icon(Icons.refresh), onPressed: controller.reset),
              IconButton(
                  icon: const Icon(Icons.zoom_in),
                  onPressed: () =>
                      controller.addTransition(CropImageData(scale: 1.33))),
              IconButton(
                  icon: const Icon(Icons.zoom_out),
                  onPressed: () =>
                      controller.addTransition(CropImageData(scale: 0.75))),
              IconButton(
                  icon: const Icon(Icons.rotate_left),
                  onPressed: () =>
                      controller.addTransition(CropImageData(angle: -pi / 4))),
              IconButton(
                  icon: const Icon(Icons.rotate_right),
                  onPressed: () =>
                      controller.addTransition(CropImageData(angle: pi / 4))),
              IconButton(
                icon: const Icon(Icons.crop),
                onPressed: () async {
                  final image = await controller.onCropImage();
                  if (image != null) {
                    BlocProvider.of<FirebaseDataBloc>(context)
                        .add(FirebaseProfilePhotochanged(image.bytes));
                    Navigator.of(context).pop();
                  }
                },
              ),
            ],
          ),
          SizedBox(height: MediaQuery.of(context).padding.bottom),
        ],
      ),
    );
  }
}
