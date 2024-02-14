import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:photo_view/photo_view.dart';
import 'package:sirwash/modules/photo_zoom/photo_zoom_controller.dart';
import 'package:sirwash/themes/ak_ui.dart';

class PhotoZoomPage extends StatelessWidget {
  final _conX = Get.put(PhotoZoomController());

  PhotoZoomPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PhotoZoomController>(
      builder: (controllerX) => Scaffold(
        appBar: AppBar(
          title: const Text(
            'Ver imagen',
            style: TextStyle(color: Colors.white),
          ),
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_rounded,
              color: Colors.white,
            ),
            onPressed: () => Get.back(),
          ),
          backgroundColor: akPrimaryColor,
        ),
        body: PhotoView(
          imageProvider: FileImage(_conX.photo),
          maxScale: PhotoViewComputedScale.covered * 2,
          minScale: PhotoViewComputedScale.contained,
        ),
      ),
    );
  }
}
