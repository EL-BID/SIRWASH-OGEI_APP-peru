import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:get/get.dart';
import 'package:sirwash/modules/osm_map/osm_map_controller.dart';

class MiscPruebaController extends GetxController {
  // final mapController = Get.put(OfflineMapController());
  final mapController = Get.put(OsmMapController(
      initialPosition: GeoPoint(latitude: -12.32, longitude: 76.32)));

  @override
  void onInit() {
    super.onInit();

    debugPrint('onInit MISCPRUEBA');
  }

  @override
  void onClose() {
    debugPrint('onClose MISCPRUEBA');
    super.onClose();
  }

  void lanzar() {
    debugPrint('lanzando');
  }
}
