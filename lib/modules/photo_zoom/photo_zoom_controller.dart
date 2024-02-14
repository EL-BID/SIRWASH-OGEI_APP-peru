import 'dart:io';

import 'package:get/get.dart';

class PhotoZoomController extends GetxController {
  late File photo;

  @override
  void onInit() {
    super.onInit();

    if (Get.arguments is PhotoZoomArguments) {
      final arguments = Get.arguments as PhotoZoomArguments;
      photo = arguments.file;
    } else {
      throw Exception('Params must be send');
    }
  }
}

class PhotoZoomArguments {
  final File file;
  const PhotoZoomArguments({required this.file});
}
