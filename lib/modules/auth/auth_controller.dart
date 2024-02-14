import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:sirwash/constants/constants.dart';
import 'package:sirwash/data/models/tipo_encuesta.dart';
import 'package:sirwash/data/models/user.dart';
import 'package:sirwash/data/models/user_credentials.dart';
import 'package:sirwash/modules/prefs/prefs_controller.dart';
import 'package:sirwash/routes/app_pages.dart';

class AuthController extends GetxController {
  final _prefsX = Get.find<PrefsController>();

  TargetPlatform platform = TargetPlatform.android;

  PackageInfo _packageInfo = PackageInfo(
    appName: 'Unknown',
    packageName: 'Unknown',
    version: 'Unknown',
    buildNumber: 'Unknown',
    buildSignature: 'Unknown',
  );
  PackageInfo get packageInfo => _packageInfo;

  UserCredentials? _userCredentials;
  UserCredentials? get userCredentials => _userCredentials;

  bool get hasCredentials {
    return userCredentials?.hasCredentials ?? false;
  }

  User? _user;
  User? get user => _user;

  void setUser(User? data) => _user = data;

  // Getbuilders Id's
  final gbMenuDrawer = 'gbMenuDrawer';

  @override
  void onInit() {
    super.onInit();

    _initPackageInfo();
  }

  Future<void> _initPackageInfo() async {
    final info = await PackageInfo.fromPlatform();
    _packageInfo = info;
  }

  /// Almacena las credenciales en las preferencias del usuario y en memoria del
  /// controlar Auth.
  Future<void> saveUserCredentialsInStore(UserCredentials? credentials) async {
    _userCredentials = credentials;
    await _prefsX.setUserCredentialStored(credentials);
  }

  /// Verifica que existe un [UserCredentials] para luego ser enviado
  /// a la página de Home, caso contrario, es enviado al login.
  ///
  /// Un usuario anónimo también es de la clase [UserCredentials], pero
  /// el campo hasCredentials permanece en false.
  Future<void> handleUserStatus() async {
    final credentialsFromPrefs = _prefsX.userCredentialStored;
    if (credentialsFromPrefs != null) {
      _userCredentials = credentialsFromPrefs;
    }

    if (_userCredentials != null) {
      Get.offAllNamed(AppRoutes.HOME);
    } else {
      Get.offAllNamed(AppRoutes.LOGIN_FORM);
    }
  }

  /// Cierra la sesión de usuario y limpia AuthController
  void logout() async {
    await saveUserCredentialsInStore(null);
    setUser(null);
    await _prefsX.deleteAll();

    handleUserStatus();
  }

  void refreshMenuDrawer() {
    update([gbMenuDrawer]);
  }

  /// Si es un usuario registrado, devuelve solo
  /// ls enuestas que le fueron asignadas desde el backend
  ///
  /// Si es un usuario anónimo, devuelve todas las encuestas
  List<TipoEncuesta> encuestasDelUsuario() {
    if (hasCredentials) {
      List<TipoEncuesta> enabled = [];

      final userModules =
          _userCredentials!.modules.map((e) => e.keycode).toList();
      for (var encuesta in encuestasApp) {
        if (userModules.contains(encuesta.keycode)) {
          enabled.add(encuesta);
        }
      }

      return enabled;
    } else {
      return encuestasApp;
    }
  }
}
