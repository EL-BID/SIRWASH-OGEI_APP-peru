import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sirwash/constants/constants.dart';
import 'package:sirwash/data/providers/db_provider.dart';
import 'package:sirwash/data/providers/settings_provider.dart';
import 'package:sirwash/modules/auth/auth_controller.dart';
import 'package:sirwash/modules/global_settings/global_settings_controller.dart';
import 'package:sirwash/themes/ak_ui.dart';
import 'package:sirwash/utils/utils.dart';
import 'package:sirwash/widgets/widgets.dart';

import 'widgets/downloading_map_layer.dart';

class SettingsController extends GetxController {
  final settingsProvider = SettingsProvider();
  final _authX = Get.find<AuthController>();

  final globalSettings = Get.find<GlobalSettingsController>();

  final gbOptionOffline = 'gbOptionOffline';
  final gbSettings = "gbSettings";

  final synchronizingCentro = false.obs;
  final synchronizingSap = false.obs;
  final synchronizingPrestadores = false.obs;
  final synchronizingDominios = false.obs;

  final deletingCloroResidual = false.obs;
  final deletingComponenteSap = false.obs;
  final deletingContinuidadServicio = false.obs;
  final deletingCloracion = false.obs;

  RxBool isLightTheme = false.obs;
  bool get isLightThemeDark => isLightTheme.value;

  late BuildContext context;

  late PathHandler pathHandler;

  @override
  void onInit() {
    super.onInit();

    _init();
  }

  Future<void> _init() async {
    pathHandler = await FileMgr().getLocalPathHandler("");

    _verificarPesoMapa();
  }

  void setContext(BuildContext c) => context = c;

  createBackup() async {
    await DBProvider.db.backupDB();
    AppSnackbar().success(message: "Respaldo creado.");
  }

  restoreBackup() async {
    await DBProvider.db.restoreDB();
    AppSnackbar().success(message: "Se restauró con éxito.");
  }

  void changeThemeMode() {
    if (isLightTheme.value) {
      Get.changeTheme(ThemeData.light());
    } else {
      Get.changeTheme(ThemeData.dark());
    }
    isLightTheme.value = !isLightTheme.value;
  }

  Future<void> changeAppMode() async {
    // Valida que el mapa se haya descargado antes de activar modo offline
    if (!globalSettings.isOfflineMode) {
      if (!(await _existeMapaOffline())) {
        AppSnackbar().warning(
            message:
                "Debes descargar el archivo .map antes de activar el modo offline");
        return;
      }
    }

    globalSettings.toggleAppMode();
    update([gbOptionOffline]);
  }

  bool isLoginValidated() {
    final logged = _authX.hasCredentials;
    if (!logged) {
      AppSnackbar()
          .warning(message: "¡Debe iniciar sesión para efectuar la acción!");
    }
    return logged;
  }

  /// Obiene los centros poblados del backend y las almacena
  /// en el SQLite local de la aplicación
  Future<void> centroPobladoSync() async {
    if (!isLoginValidated()) return;

    synchronizingCentro.value = true;
    await tryCatch(code: () async {
      final list = await settingsProvider.listAllCentrosPoblado();

      await DBProvider.db.deleteAllCentroPoblado();
      await DBProvider.db.insertCentroPoblado(list);

      showSyncSuccessToast(prefix: 'Centros Poblados');
    });
    synchronizingCentro.value = false;
  }

  /// Obiene los SAP del backend y las almacena
  /// en el SQLite local de la aplicación
  Future<void> sapSync() async {
    if (!isLoginValidated()) return;

    synchronizingSap.value = true;
    await tryCatch(code: () async {
      final list = await settingsProvider.listAllSap();

      await DBProvider.db.deleteAllSap();
      await DBProvider.db.insertSap(list);

      showSyncSuccessToast(prefix: 'SAP');
    });
    synchronizingSap.value = false;
  }

  /// Obiene los prestadores del backend y las almacena
  /// en el SQLite local de la aplicación
  Future<void> prestadoresSync() async {
    if (!isLoginValidated()) return;

    synchronizingPrestadores.value = true;
    await tryCatch(code: () async {
      final list = await settingsProvider.listAllPrestadores();

      await DBProvider.db.deleteAllPrestadores();
      await DBProvider.db.insertPrestadores(list);

      showSyncSuccessToast(prefix: 'Prestadores');
    });
    synchronizingPrestadores.value = false;
  }

  /// Obiene los otras tablas maestras del backend y las almacena
  /// en el SQLite local de la aplicación
  Future<void> dominiosSync() async {
    if (!isLoginValidated()) return;

    synchronizingDominios.value = true;
    await tryCatch(code: () async {
      await startSyncCaudalAguas();
      await startSyncComponentes();
      await startSyncFrecuencias();
      await startSyncHoras();
      await startSyncInsumos();
      await startSyncMedidaBriquetas();
      await startSyncMedidaGas();
      await startSyncMedidaHipocloritos();
      await startSyncTipoImagenes();

      showSyncSuccessToast(prefix: 'Dominios');
    });
    synchronizingDominios.value = false;
  }

  Future<void> startSyncCaudalAguas() async {
    final list = await settingsProvider.listAllCaudalAguas();
    await DBProvider.db.deleteAllCaudalAguas();
    await DBProvider.db.insertCaudalAguas(list);
  }

  Future<void> startSyncComponentes() async {
    final list = await settingsProvider.listAllComponentes();
    await DBProvider.db.deleteAllComponentes();
    await DBProvider.db.insertComponentes(list);
  }

  Future<void> startSyncFrecuencias() async {
    final list = await settingsProvider.listAllFrecuencias();
    await DBProvider.db.deleteAllFrecuencias();
    await DBProvider.db.insertFrecuencias(list);
  }

  Future<void> startSyncHoras() async {
    final list = await settingsProvider.listAllHoras();
    await DBProvider.db.deleteAllHoras();
    await DBProvider.db.insertHoras(list);
  }

  Future<void> startSyncInsumos() async {
    final list = await settingsProvider.listAllInsumos();
    await DBProvider.db.deleteAllInsumos();
    await DBProvider.db.insertInsumos(list);
  }

  Future<void> startSyncMedidaBriquetas() async {
    final list = await settingsProvider.listAllMedidaBriquetas();
    await DBProvider.db.deleteAllMedidaBriquetas();
    await DBProvider.db.insertMedidaBriquetas(list);
  }

  Future<void> startSyncMedidaGas() async {
    final list = await settingsProvider.listAllMedidaGas();
    await DBProvider.db.deleteAllMedidaGas();
    await DBProvider.db.insertMedidaGas(list);
  }

  Future<void> startSyncMedidaHipocloritos() async {
    final list = await settingsProvider.listAllMedidaHipocloritos();
    await DBProvider.db.deleteAllMedidaHipocloritos();
    await DBProvider.db.insertMedidaHipocloritos(list);
  }

  Future<void> startSyncTipoImagenes() async {
    final list = await settingsProvider.listAllTipoImagenes();
    await DBProvider.db.deleteAllTipoImagenes();
    await DBProvider.db.insertTipoImagenes(list);
  }

  // ************** ELIMINACIONES ****************
  /// En esta sección estás las funciones que eliminan la data
  /// de encuestas para liberar almacenamiento en el dispositivo
  /// Estas eliminan todas las encuestas, independiente de si
  /// fueron enviadas o no.

  Future<void> deleteCloroResidual() async {
    if (!isLoginValidated()) return;

    if (!await requestConfirmationSurveys('Cloro residual')) return;

    deletingCloroResidual.value = true;
    await tryCatch(code: () async {
      await DBProvider.db.deleteAllCloroResidual();

      showSyncSuccessToast(prefix: 'Encuestas eliminadas');
    });
    deletingCloroResidual.value = false;
  }

  Future<void> deleteComponenteSap() async {
    if (!isLoginValidated()) return;

    if (!await requestConfirmationSurveys(
        'Limpieza y Desinfección de componentes del SAP')) return;

    deletingComponenteSap.value = true;
    await tryCatch(code: () async {
      await DBProvider.db.deleteAllComponenteSap();

      showSyncSuccessToast(prefix: 'Encuestas eliminadas');
    });
    deletingComponenteSap.value = false;
  }

  Future<void> deleteContinuidadServicio() async {
    if (!isLoginValidated()) return;

    if (!await requestConfirmationSurveys('Continuidad de Servicio')) return;

    deletingContinuidadServicio.value = true;
    await tryCatch(code: () async {
      await DBProvider.db.deleteAllContinuidadServicio();

      showSyncSuccessToast(prefix: 'Encuestas eliminadas');
    });
    deletingContinuidadServicio.value = false;
  }

  Future<void> deleteCloraciones() async {
    if (!isLoginValidated()) return;

    if (!await requestConfirmationSurveys('Cloraciones')) return;

    deletingCloracion.value = true;
    await tryCatch(code: () async {
      await DBProvider.db.deleteAllCloraciones();

      showSyncSuccessToast(prefix: 'Encuestas eliminadas');
    });
    deletingCloracion.value = false;
  }

  void showSyncSuccessToast({String? prefix}) {
    final prefixTxt = prefix != null ? '$prefix :' : '';
    AppSnackbar().success(message: "$prefixTxt Sincronizado con éxito.");
  }

  /// Función utilitaria que muestra un cuadro de confirmación antes de
  /// eliminar las encuestas del SQLite
  Future<bool> requestConfirmationSurveys(String nombreTabla) async {
    final result = await Helpers.confirmDialog(
      title: '¿Limpiar tabla: $nombreTabla?',
      subTitle:
          'Esta acción eliminará todas las encuestas enviadas y no enviadas',
      yesText: 'Sí, eliminar',
      yesBackgroundColor: akRedColor,
      noText: 'No, cancelar',
    );

    return result ?? false;
  }

  Future<bool> requestConfirmationDeleteMap() async {
    final result = await Helpers.confirmDialog(
      title: '¿Deseas eliminar el mapa offline?',
      subTitle: 'Esta acción eliminará el archivo del almacenamiento',
      yesText: 'Sí, eliminar',
      yesBackgroundColor: akRedColor,
      noText: 'No, cancelar',
    );

    return result ?? false;
  }

  // ************** DESCARGA DE MAPA METHODS ****************
  final downloadProgress = RxnDouble(null);
  final downloadSizeLabel = RxString('');

  final storedMapSize = RxnInt(0);

  CancelToken cancelToken = CancelToken();

  Future<bool> _existeMapaOffline() async {
    return await pathHandler.exists(K_OFFLINE_MAP_NAME);
  }

  Future<void> _verificarPesoMapa() async {
    if (await _existeMapaOffline()) {
      final fileMap = File(pathHandler.getPath(K_OFFLINE_MAP_NAME));
      storedMapSize.value = await fileMap.length();
    } else {
      storedMapSize.value = null;
    }
  }

  Future<void> borrarMapaOffline() async {
    if (!await requestConfirmationDeleteMap()) return;

    if (globalSettings.isOfflineMode) {
      AppSnackbar().warning(
          message:
              "Debes desactivar el Modo Offline antes de borrar el Archivo .map");
      return;
    }

    if (await _existeMapaOffline()) {
      final fileMap = File(pathHandler.getPath(K_OFFLINE_MAP_NAME));
      await fileMap.delete();
      _verificarPesoMapa();
    }
  }

  Future<void> _onCancelarBotonTap() async {
    cancelToken.cancel();
  }

  Future<void> empezarDescargaMapa() async {
    // Reset values
    downloadProgress.value = null;
    downloadSizeLabel.value = 'Calculando...';

    try {
      // Reinicia el cancelToken para iniciar una nueva descarga
      cancelToken = CancelToken();
      showDialog(
          barrierDismissible: false,
          barrierColor: Colors.transparent,
          context: context,
          builder: (_) => DownloadingMapLayer(
                percentDownload: downloadProgress,
                sizeDownloadedText: downloadSizeLabel,
                onCancelTap: _onCancelarBotonTap,
              ));
      // print(pathHandler.getPath(fileName));
      await settingsProvider.downloadMap(
          pathHandler.getPath(K_OFFLINE_MAP_NAME),
          cancelToken: cancelToken, onReceiveProgress: ((received, total) {
        if (total != -1) {
          downloadProgress.value = received / total;
          downloadSizeLabel.value =
              '${NumberFormat.bytesToMB(received)} MB de ${NumberFormat.bytesToMB(total)} MB';
        }
      }));
    } catch (e) {
      if (e is DioError) {
        if (CancelToken.isCancel(e)) {
          // No hace falta eliminar el archivo porque Dio lo hace
          // cuando una descarga se cancela
          debugPrint('Descarga cancelada');
        } else {
          debugPrint('Hubo un error Dio.');
        }
      } else {
        debugPrint('Hubo un error inesperado.');
      }
    } finally {
      // Cierra el downloading layer
      Get.back();
    }

    // Delay necesario que espera a que el archivo
    // sea eliminado en caso de cancelar la descarga
    await Future.delayed(const Duration(milliseconds: 100));

    // Verifica si hay un archivo descargado;
    await _verificarPesoMapa();
  }
}
