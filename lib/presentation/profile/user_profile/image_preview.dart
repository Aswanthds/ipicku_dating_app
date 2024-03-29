import 'package:flutter/material.dart';
import 'package:ipicku_dating_app/presentation/ui_utils/colors.dart';

class ImagePreviewPage extends StatelessWidget {
  final String imageUrl;

  const ImagePreviewPage({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black38,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: AppTheme.white),
        backgroundColor: Colors.transparent,
      ),
      body: Hero(
        tag: 'userImage-$imageUrl',
        child: InteractiveViewer(
          panEnabled: false,
          boundaryMargin: const EdgeInsets.all(80),
          minScale: 0.5,
          maxScale: 4,
          child: Center(
            child: Image.network(
              imageUrl,
              fit: BoxFit.fitWidth,
            ),
          ),
        ),
      ),
    );
  }
}
