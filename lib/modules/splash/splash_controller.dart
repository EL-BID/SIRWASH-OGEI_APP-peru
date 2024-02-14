import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sirwash/routes/app_pages.dart';
import 'package:sirwash/utils/utils.dart';

class SplashController extends GetxController {
  // final authX = Get.find<AuthController>();
  late Image logoWhiteCache;
  late Image loginBgCache;

  final logoCacheLoaded = false.obs;

  @override
  void onInit() {
    super.onInit();
    _preloadAndAnalyzeSession();
  }

  Future<void> _preloadAndAnalyzeSession() async {
    logoCacheLoaded.value = true;
    await Helpers.sleep(1900);
    Get.offAllNamed(AppRoutes.LOGIN_FORM);
  }
}
