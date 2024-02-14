import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TabsController extends GetxController
    with GetSingleTickerProviderStateMixin {
  late TabController controller;

  @override
  void onInit() {
    super.onInit();
    controller = TabController(vsync: this, length: 4);
  }

  /// Cambia la página visible
  void goTab(int _index) {
    controller.index = _index;
  }
}
