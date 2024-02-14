import 'package:get/get.dart';
import 'package:sirwash/data/models/tipo_encuesta.dart';
import 'package:sirwash/modules/auth/auth_controller.dart';
import 'package:sirwash/modules/encuestas/cloro_residual/cloro_residual_controller.dart';
import 'package:sirwash/routes/app_pages.dart';

import 'cloracion/cloracion_controller.dart';
import 'componente_sap/componente_sap_controller.dart';
import 'continuidad_servicio/continuidad_servicio_controller.dart';

class EncuestasHomeController extends GetxController {
  final _authX = Get.find<AuthController>();
  final fetching = true.obs;

  List<TipoEncuesta> encuestas = [];

  @override
  void onInit() {
    super.onInit();
    _init();
  }

  Future<void> _init() async {
    encuestas.addAll(_authX.encuestasDelUsuario());
    await Future.delayed(const Duration(milliseconds: 1500));
    fetching.value = false;
  }

  void onSelectItem(TipoEncuesta selected) {
    switch (selected.key) {
      case EncuestaKey.cloroResidual:
        Get.toNamed(AppRoutes.ENCUESTA_CLORO_RESIDUAL,
            arguments: const EncuestaCloroResidualArguments());
        break;

      case EncuestaKey.componenteSap:
        Get.toNamed(AppRoutes.ENCUESTA_COMPONENTE_SAP,
            arguments: const EncuestaComponenteSapArguments());
        break;

      case EncuestaKey.continuidadServicio:
        Get.toNamed(AppRoutes.ENCUESTA_CONTINUIDAD_SERVICIO,
            arguments: const EncuestaContinuidadServicioArguments());
        break;

      case EncuestaKey.cloracion:
        Get.toNamed(AppRoutes.ENCUESTA_CLORACION,
            arguments: const EncuestaCloracionArguments());
        break;
    }
  }
}
