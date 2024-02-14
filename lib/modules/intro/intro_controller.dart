import 'package:get/get.dart';
import 'package:sirwash/routes/app_pages.dart';

class IntroController extends GetxController {
  void onDoneButtonTap() {
    Get.offAllNamed(AppRoutes.HOME);
    return;
  }
}
