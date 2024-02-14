import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:mapsforge_flutter/core.dart';
import 'package:mapsforge_flutter/marker.dart';
import 'package:sirwash/modules/global_settings/global_settings_controller.dart';
import 'package:sirwash/modules/offline_map/offline_map_controller.dart';
import 'package:sirwash/modules/osm_map/osm_map_controller.dart';
import 'package:sirwash/widgets/custom_markers.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class FormMapWrapperController extends GetxController {
  /// Posiciones y Zoom iniciales
  final double initialLat = -12.0460026;
  final double initialLong = -77.0305923;
  final double initZoom = 17.0;

  /// Definición de los controladores online y offline
  late OfflineMapController offlineMapX;
  late OsmMapController osmMapX;

  bool _offlineMode = false;
  bool get offlineMode => _offlineMode;

  final bool disableStreamPosition;
  final loadingMap = true.obs;
  final localizando = false.obs;

  // GetBuilds ID's
  final gbSlidePanel = 'gbSlidePanel';
  // final gbMapButtons = 'gbMapButtons';

  final buildMapWigets = false.obs;

  final void Function(Position)? onPositionFound;
  final VoidCallback? onMapsReady;
  final Future<bool> Function() backLogic;

  FormMapWrapperController({
    this.disableStreamPosition = false,
    this.onPositionFound,
    this.onMapsReady,
    required this.backLogic,
  });

  @override
  void onInit() {
    super.onInit();

    final globalSettings = Get.find<GlobalSettingsController>();
    _offlineMode = globalSettings.isOfflineMode;

    /// Inyecta los controladores según la opción que el usuario
    /// haya selecionado desde la página de ajustes
    if (offlineMode) {
      offlineMapX = Get.put(OfflineMapController(
        initialPosition: LatLong(initialLat, initialLong),
        initZoom: initZoom,
      ));
      offlineMapX.onGestureEvent = disableTracking;
    } else {
      osmMapX = Get.put(OsmMapController(
        initialPosition: GeoPoint(latitude: initialLat, longitude: initialLong),
        initZoom: initZoom,
      ));
      osmMapX.onPointerMoveEvent = disableTracking;
    }

    /// Muestra los mapas en pantalla
    _injectMapsToTreeWidgets();
  }

  Future<void> _injectMapsToTreeWidgets() async {
    // Delay que espera a que la transición de página se efectúe
    await Future.delayed(const Duration(milliseconds: 1000));
    // En este punto, los widgets de los mapas han sido mostrados en pantalla
    buildMapWigets.value = true;
  }

  bool _trackingEnabled = true;
  void disableTracking() {
    if (!_trackingEnabled) return;
    debugPrint('disableTracking...');
    _trackingEnabled = false;
  }

  void _enableTracking() {
    if (_trackingEnabled) return;
    debugPrint('enableTracking...');
    _trackingEnabled = true;
  }

  @override
  void onClose() {
    _userPositionSubscription?.cancel();
    super.onClose();
  }

  // **************************************************
  // * MAPS METHODS
  // **************************************************
  // INITIAL METHOD. AFTER MAP WERE LOADED
  Future<void> onMapsWidgetsLoaded() async {
    debugPrint('Maps loaded!');
    await Future.delayed(const Duration(seconds: 2));
    loadingMap.value = false;

    if (!disableStreamPosition) {
      _listenPosition();
    }

    onMapsReady?.call();
  }

  /// Centra el mapa en la posición actual del GPS
  Future<void> centerToCurrentPosition() async {
    if (_currentPosition == null) return;
    _enableTracking();

    jumpTo(_currentPosition!.latitude, _currentPosition!.longitude);
  }

  /// Mueve el mapa hacia una posición específica
  Future<void> jumpTo(double latitude, double longitude) async {
    if (offlineMode) {
      offlineMapX.jumpToPosition(
        latitude,
        longitude,
      );
    } else {
      osmMapX.jumpToPosition(
        latitude,
        longitude,
      );
    }
  }

  /// Agrega un marcador en los mapas
  Future<void> addUniqueMarker(double latitude, double longitude) async {
    if (offlineMode) {
      offlineMapX.clearMarkers();
      final marker = disableStreamPosition
          ? PoiMarker(
              displayModel: DisplayModel(),
              src: 'assets/icons/marker.svg',
              height: 90,
              width: 90,
              latLong: LatLong(latitude, longitude),
            )
          : PoiMarker(
              displayModel: DisplayModel(),
              src: 'assets/icons/current_marker.svg',
              height: 115,
              width: 115,
              latLong: LatLong(latitude, longitude),
            );
      offlineMapX.addCustomMarker(marker);
    } else {
      final markerPosition = GeoPoint(latitude: latitude, longitude: longitude);
      final markerIcon = disableStreamPosition
          ? const MarkerIcon(iconWidget: FixedMarker())
          : const MarkerIcon(iconWidget: CurrentMarker());

      if (osmMapX.lastGeoPoint == null) {
        await osmMapX.addCustomMarker(markerPosition, markerIcon: markerIcon);
      } else {
        await osmMapX.changeLocationMarker(
          osmMapX.lastGeoPoint!,
          markerPosition,
        );
      }
    }
  }

  /// Cambia el tile superior del mapa, si está disponbiled
  void changeTileLayer() {
    if (offlineMode) {
      offlineMapX.toggleLayer();
    } else {
      osmMapX.toggleLayer();
    }
  }

  /// Detecta cuando un usuario intenta regresar mediante los gestos del celular
  /// o si selecciona la flecha hacia la izquierda
  Future<bool> onBackIntent() async {
    return await backLogic.call();
  }

  // **************************************************
  // * POSITION/GEOLOCATOR METHODS
  // **************************************************
  StreamSubscription<Position>? _userPositionSubscription;
  StreamSubscription<Position>? get userPosition => _userPositionSubscription;

  Position? _currentPosition;
  Position? get currentPosition => _currentPosition;

  /// Activa un listener que estará pendiente de los cambios en las posición
  /// del GPS.
  Future<void> _listenPosition() async {
    localizando.value = true;

    await _userPositionSubscription?.cancel();
    // Obtiene la última posición GPS almacenada
    _currentPosition = await Geolocator.getCurrentPosition();
    updateLatLngLabels(_currentPosition!);
    await _onCurrentPositionFound(_currentPosition!);
    // Inicia el stream para escuchar los cambios de posición
    _userPositionSubscription = Geolocator.getPositionStream(
      desiredAccuracy: LocationAccuracy.high,
      distanceFilter: 10,
    ).listen((position) async {
      updateLatLngLabels(position);
      debugPrint('Updated position: ${position.toString()}');
      _currentPosition = position;
      await _onCurrentPositionFound(_currentPosition!);
    });
  }

  final latitudeLbl = 0.0.obs;
  final longitudeLbl = 0.0.obs;

  /// Actualiza el texto de coordenadas que aparece en la cabecera
  /// del panel modal del wrapper, utilizado por el stream de cambio
  /// de posiciones
  void updateLatLngLabels(Position position) {
    latitudeLbl.value = position.latitude;
    longitudeLbl.value = position.longitude;
  }

  /// Utilizado por otros controladores para asignar el texto de coordenadas
  void forceSetLatLngLabels(double latitude, double longitude) {
    latitudeLbl.value = latitude;
    longitudeLbl.value = longitude;
  }

  /// Cuando la posición del GPS cambia, esta función agrega un marcador
  /// en los mapas y centra la vista a este.
  Future<void> _onCurrentPositionFound(Position position) async {
    onPositionFound?.call(position);

    await addUniqueMarker(
        _currentPosition!.latitude, _currentPosition!.longitude);
    if (_trackingEnabled) {
      centerToCurrentPosition();
    }

    accuracy.value = position.accuracy.toPrecision(2);
    if (localizando.value) localizando.value = false;
  }

  final accuracy = 0.0.obs;
  bool get isGoodAccuracy => accuracy.value > 0.0 && accuracy.value <= 10.0;

  // **************************************************
  // * SLIDER PANEL METHODS
  // **************************************************
  final slidePanelController = PanelController();
  final panelTitleKey = GlobalKey();
  final panelBodyKey = GlobalKey();
  bool panelHeightUpdated = false;
  bool heightFromWidgets = false;
  double panelHeightOpen = 400;
  double panelHeightClosed = 190.0;

  /// Función utilitaria para detectar el contenido hijo del modal
  /// y establecer los tamaños correctos del modal
  void updatePanelMaxHeight() {
    if (panelHeightUpdated) return;
    try {
      final rObjectTitle = panelTitleKey.currentContext?.findRenderObject();
      final rBoxTitle = rObjectTitle as RenderBox;
      final rObjectBody = panelBodyKey.currentContext?.findRenderObject();
      final rBoxBody = rObjectBody as RenderBox;
      final totalHeight = rBoxTitle.size.height + rBoxBody.size.height;
      final maxPanelHeight = (Get.height * 0.8);

      if (totalHeight < maxPanelHeight) {
        panelHeightOpen = totalHeight;
        heightFromWidgets = true;
      } else {
        panelHeightOpen = maxPanelHeight;
      }

      panelHeightUpdated = true;
      update([gbSlidePanel]);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  /// Llamar esta función para recalcular la altura de
  /// los widgets hijos del modal y corregir el scroll
  void forceUpdatePanel() {
    panelHeightUpdated = false;
    heightFromWidgets = false;
    updatePanelMaxHeight();
  }
}
