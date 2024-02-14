import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sirwash/data/models/user_credentials.dart';
import 'package:sirwash/data/providers/auth_provider.dart';
import 'package:sirwash/modules/auth/auth_controller.dart';
import 'package:sirwash/routes/app_pages.dart';
import 'package:sirwash/utils/utils.dart';
import 'package:sirwash/widgets/widgets.dart';

class LoginFormController extends GetxController {
  RxBool isLightTheme = true.obs;

  final _authX = Get.find<AuthController>();
  final _authProvider = AuthProvider();

  final usernameCtlr = TextEditingController();
  final passwordCtlr = TextEditingController();

  RxBool loading = false.obs;

  void onLoginButtonTap() {
    if (loading.value) return;

    if (_validateUsername() != null) {
      AppSnackbar().warning(message: _validateUsername() ?? '');
      return;
    }

    if (_validatePassword() != null) {
      AppSnackbar().warning(message: _validatePassword() ?? '');
      return;
    }

    Get.focusScope?.unfocus();
    _login();
  }

  Future<void> _login() async {
    await tryCatch(code: () async {
      loading.value = true;

      await Helpers.sleep(1500);
      final loginResp = await _authProvider.loginWithEmail(
        usernameCtlr.text.trim(),
        passwordCtlr.text.trim(),
      );

      if (!loginResp.success) {
        AppSnackbar()
            .error(message: loginResp.message ?? 'Hubo un error en el login');
        return;
      }

      /// Solo en este punto se está adjuntando el token manualmente,
      /// Porque aún no se han guardado las credenciales en el controlador
      final options = Options(headers: {'Authorization': loginResp.result});
      final user = await _authProvider.getEmployeeByUserId(
        loginResp.iduser!,
        options: options,
      );

      final modules = await _authProvider.getModulesByUserId(
        loginResp.iduser,
        options: options,
      );

      final centrosPoblados = await _authProvider.getCentrosPobladosByUserId(
        loginResp.iduser,
        options: options,
      );

      final credentials = UserCredentials(
        hasCredentials: true,
        iduser: user.usuarioId,
        usuario: user.usuario,
        usuarioAlias: user.usuarioAlias,
        nombre: user.nombres,
        apellido: user.apellidos,
        dni: user.dni,
        perfil: user.perfil,
        estado: user.estado,
        token: loginResp.result,
        modules: modules,
        misCentrosPoblados: centrosPoblados,
      );

      /// A partir de aquí, todas las peticiones serán enviadas
      /// con el token debido al interceptor
      await _authX.saveUserCredentialsInStore(credentials);
      _authX.handleUserStatus();
    });
    loading.value = false;
  }

  /// Actualiza el AuthController con un usuario del tipo anónimo
  /// El usuario del tipo anónimo tienen [hasCredentials] en false.
  Future<void> loginWithNoCredentials() async {
    var userWithoutCredentials = UserCredentials(hasCredentials: false);
    await _authX.saveUserCredentialsInStore(userWithoutCredentials);
    Get.offAllNamed(AppRoutes.HOME);
  }

  void onResetPasswordTap() {
    if (loading.value) return;

    _resetPassword();
  }

  Future<void> _resetPassword() async {
    Get.focusScope?.unfocus();
    Get.toNamed(AppRoutes.LOGIN_LOST_PASSWORD);
  }

  // Validators
  String? _validateUsername() {
    if (usernameCtlr.text.trim().length >= 3) {
      return null;
    }
    return 'Nombre de usuario requerido';
  }

  String? _validatePassword() {
    if (passwordCtlr.text.trim().length >= 3) {
      return null;
    }
    return 'Contraseña requerida';
  }
}
