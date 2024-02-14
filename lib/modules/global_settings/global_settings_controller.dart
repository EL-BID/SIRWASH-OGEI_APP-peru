import 'package:get/get.dart';

class GlobalSettingsController extends GetxController {
  bool _isOfflineMode = false;
  bool get isOfflineMode => _isOfflineMode;

  /// Intercambia el tipo de mapas entre Online/Offline
  void toggleAppMode() {
    _isOfflineMode = !_isOfflineMode;
  }
}
