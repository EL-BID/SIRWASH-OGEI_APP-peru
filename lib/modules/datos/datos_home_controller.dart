import 'package:get/get.dart';
import 'package:sirwash/data/models/tipo_encuesta.dart';
import 'package:sirwash/modules/auth/auth_controller.dart';
import 'package:sirwash/routes/app_pages.dart';

import 'encuestas_saved/encuestas_saved_controller.dart';

class DatosHomeController extends GetxController {
  final _authX = Get.find<AuthController>();

  final fetching = true.obs;
  List<TipoEncuesta> encuestas = [];

  @override
  void onInit() {
    super.onInit();
    _init();
  }

  Future<void> _init() async {
    /// Muestra en pantalla la lista de encuestas según el tipo de usuario
    ///
    /// Si es un usuario registrado (con crendenciales) lista sólo las encuestas
    /// que le fueron asignadas a su perfil
    ///
    /// Si es un usuario anónimo (sin credenciales) se listan todas las encuestas
    encuestas.addAll(_authX.encuestasDelUsuario());
    await Future.delayed(const Duration(milliseconds: 1500));
    fetching.value = false;
  }

  void onTipoEncuestaTap(TipoEncuesta tipo) {
    Get.toNamed(
      AppRoutes.DATOS_ENCUESTAS_SAVED,
      arguments: EncuestasSavedArguments(tipoEncuesta: tipo),
    );
  }
}
