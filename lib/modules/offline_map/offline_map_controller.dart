import 'dart:async';

import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:mapsforge_flutter/core.dart';
import 'package:mapsforge_flutter/maps.dart';
import 'package:mapsforge_flutter/marker.dart';
import 'package:sirwash/constants/constants.dart';
import 'package:sirwash/modules/offline_map/hidden_context_menu_builder.dart';
import 'package:sirwash/modules/offline_map/marker_overlay_state.dart';
import 'package:sirwash/utils/utils.dart';

class OfflineMapController extends GetxController {
  final isGreen = false.obs;

  // Create the displayModel which defines and holds the view/display settings
  // like maximum zoomLevel.
  final displayModel = DisplayModel(deviceScaleFactor: 2);
  // Create the cache for assets
  final symbolCache = FileSymbolCache();
  // Create a store for markers
  final markerDataStore = MarkerDataStore();

  // Custom properties
  final LatLong initialPosition;
  final double initZoom;

  StreamSubscription? _gestureEventsSub;
  VoidCallback? onGestureEvent;

  OfflineMapController({
    required this.initialPosition, // Centro de Lima
    this.initZoom = 10.0,
  });

  @override
  void onClose() {
    _gestureEventsSub?.cancel();
    super.onClose();
  }

  // bool _firstMapModelCreated = false;
  bool customTheme = true;

  Future<MapModel> createMapModel() async {
    PathHandler pathHandler = await FileMgr().getLocalPathHandler("");
    // Load the previously downloaded offline map from settings page
    final mapFile =
        await MapFile.from(pathHandler.getPath(K_OFFLINE_MAP_NAME), null, null);

    // Create the render theme which specifies how to render the informations
    // from the mapfile.
    final renderTheme = await RenderThemeBuilder.create(
      displayModel,
      customTheme
          ? 'assets/maps/render_themes/custom.xml'
          : 'assets/maps/render_themes/defaultrender.xml',
    );

    // Create the Renderer
    final jobRenderer =
        MapDataStoreRenderer(mapFile, renderTheme, symbolCache, true);

    // Glue everything together into two models.
    MapModel mapModel = MapModel(
      displayModel: displayModel,
      renderer: jobRenderer,
    );

    // Add MarkerDataStore to hold added markers
    mapModel.markerDataStores.add(markerDataStore);

    // _firstMapModelCreated = true;

    return mapModel;
  }

  ViewModel? mapViewModel;
  Future<ViewModel> createViewModel() async {
    mapViewModel = ViewModel(displayModel: displayModel);

    // set the initial position
    mapViewModel!.setMapViewPosition(
        initialPosition.latitude, initialPosition.longitude);
    // set the initial zoomlevel
    mapViewModel!.setZoomLevel(initZoom.toInt());
    // bonus feature: listen for long taps and add/remove a marker at the tap-positon
    mapViewModel!.addOverlay(MarkerOverlay(
        viewModel: mapViewModel!,
        markerDataStore: markerDataStore,
        symbolCache: symbolCache));

    // Changing default context menu for own implementation
    mapViewModel!.contextMenuBuilder = const HiddenContextMenuBuilder();

    _gestureEventsSub = mapViewModel!.observeGesture.listen((event) {
      onGestureEvent?.call();
    });

    return mapViewModel!;
  }

  bool _mapLoaded = false;
  Future<void> emitOnMapReady(VoidCallback? callback) async {
    if (_mapLoaded) return;
    _mapLoaded = true;
    await Future.delayed(const Duration(seconds: 2)); // Important!
    callback?.call();
  }

  // Custom methods
  void addCustomMarker(PoiMarker marker) {
    marker.initResources(symbolCache).then((value) {
      markerDataStore.addMarker(marker);
      markerDataStore.setRepaint();
    });
  }

  void clearMarkers() {
    markerDataStore.clearMarkers();
    markerDataStore.setRepaint();
  }

  void jumpToPosition(double latitude, double longitude) {
    mapViewModel?.setMapViewPosition(latitude, longitude);
  }

  final gbOsmMapKey = 'gbOsmMapKey';
  void toggleLayer() {
    // customTheme = !customTheme;
    // update([gbOsmMapKey]);
  }
}
