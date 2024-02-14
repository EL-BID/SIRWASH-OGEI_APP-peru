import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:get/get.dart';

class OsmMapController extends GetxController {
  late MapController mapController;

  // Custom properties
  final GeoPoint initialPosition;
  final double initZoom;

  GeoPoint? _lastGeoPoint;
  GeoPoint? get lastGeoPoint => _lastGeoPoint;

  VoidCallback? onPointerMoveEvent;

  OsmMapController({
    required this.initialPosition,
    this.initZoom = 10.0,
  });

  @override
  void onInit() {
    super.onInit();
    mapController = MapController(
        initMapWithUserPosition: false, initPosition: initialPosition);

    /* mapController = MapController.customLayer(
      initMapWithUserPosition: false,
      initPosition: initialPosition,
      customTile: CustomTile(
          sourceName: "maptilercloudbasic",
          tileExtension: ".png",
          urlsServers: [
            TileURLs(url: "https://api.maptiler.com/maps/basic-v2/")
          ],
          tileSize: 512,
          keyApi: const MapEntry('key', 'XOTlBV8rNUaHPljMzxH6')),
    ); */
  }

  @override
  onClose() {
    mapController.dispose();
    super.onClose();
  }

  // Custom methods
  Future<void> addCustomMarker(GeoPoint latlng,
      {MarkerIcon? markerIcon}) async {
    // Don't use await for this method to avoid bugs
    mapController.addMarker(latlng, markerIcon: markerIcon);
    _lastGeoPoint = latlng;
  }

  Future<void> clearMarkers() async {
    final geopointsList = (await mapController.geopoints);
    for (var marker in geopointsList) {
      await mapController.removeMarker(marker);
    }
    _lastGeoPoint = null;
  }

  Future<void> changeLocationMarker(GeoPoint oldLocation, GeoPoint newLocation,
      {MarkerIcon? markerIcon}) async {
    // Don't use await for this method to avoid bugs
    mapController.changeLocationMarker(
      oldLocation: oldLocation,
      newLocation: newLocation,
    );
    _lastGeoPoint = newLocation;
  }

  void jumpToPosition(double latitude, double longitude) {
    mapController
        .goToLocation(GeoPoint(latitude: latitude, longitude: longitude));
  }

  bool _hybridLayer = false;
  void toggleLayer() async {
    _hybridLayer = !_hybridLayer;

    if (_hybridLayer) {
      await mapController.changeTileLayer(
          tileLayer: CustomTile(
              sourceName: "maptilercloudhybrid",
              tileExtension: ".jpg",
              urlsServers: [
                TileURLs(url: "https://api.maptiler.com/maps/hybrid/")
              ],
              tileSize: 512,
              keyApi: const MapEntry('key', 'XOTlBV8rNUaHPljMzxH6')));
    } else {
      mapController.changeTileLayer();
    }
  }
}
