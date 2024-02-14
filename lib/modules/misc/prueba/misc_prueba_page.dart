import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sirwash/modules/misc/prueba/misc_prueba_controller.dart';
import 'package:sirwash/modules/osm_map/osm_map.dart';

class MiscPruebaPage extends StatelessWidget {
  final conX = Get.put(MiscPruebaController());

  MiscPruebaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.blue,
        padding: const EdgeInsets.all(20),
        child: OsmMap(
          conX: conX.mapController,
          onMapReady: () {
            debugPrint('asdlf');
            conX.lanzar();
          },
        ),
      ),
    );
  }
}
