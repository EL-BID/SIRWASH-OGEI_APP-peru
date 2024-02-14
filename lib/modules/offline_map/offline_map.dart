// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mapsforge_flutter/core.dart';
import 'package:sirwash/modules/offline_map/offline_map_controller.dart';

class OfflineMap extends StatelessWidget {
  final OfflineMapController conX;
  final VoidCallback? onMapReady;

  const OfflineMap({required this.conX, this.onMapReady, super.key});

  @override
  Widget build(BuildContext context) {
    conX.emitOnMapReady(onMapReady);
    return GetBuilder<OfflineMapController>(
      id: conX.gbOsmMapKey,
      builder: (_) {
        // print('buildmapa');
        return MapviewWidget(
          changeKey: 'cgkMapWidget${conX.customTheme}',
          displayModel: conX.displayModel,
          createMapModel: conX.createMapModel,
          createViewModel: conX.createViewModel,
        );
      },
    );
  }
}
