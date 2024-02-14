import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:sirwash/modules/osm_map/osm_map_controller.dart';

class OsmMap extends StatelessWidget {
  final OsmMapController conX;

  // Custom properties
  final VoidCallback? onMapReady;

  const OsmMap({required this.conX, this.onMapReady, super.key});

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerMove: (event) {
        conX.onPointerMoveEvent?.call();
      },
      child: OSMFlutter(
        controller: conX.mapController,
        onMapIsReady: (value) {
          if (value) {
            onMapReady?.call();
          }
        },
        trackMyPosition: false,
        initZoom: conX.initZoom,
        minZoomLevel: 8,
        maxZoomLevel: 19,
        stepZoom: 1.0,
      ),
    );
  }
}
