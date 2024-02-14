import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sirwash/data/models/models.dart';
import 'package:sirwash/data/models/tipo_encuesta.dart';
import 'package:sirwash/data/providers/db_provider.dart';
import 'package:sirwash/data/providers/encuestas_provider.dart';
import 'package:sirwash/modules/auth/auth_controller.dart';
import 'package:sirwash/modules/encuestas/cloracion/cloracion_controller.dart';
import 'package:sirwash/modules/encuestas/cloro_residual/cloro_residual_controller.dart';
import 'package:sirwash/modules/encuestas/componente_sap/componente_sap_controller.dart';
import 'package:sirwash/modules/encuestas/continuidad_servicio/continuidad_servicio_controller.dart';
import 'package:sirwash/routes/app_pages.dart';
import 'package:sirwash/themes/ak_ui.dart';
import 'package:sirwash/utils/utils.dart';
import 'package:sirwash/widgets/widgets.dart';

import 'selectable_entity.dart';

class EncuestasSavedController extends GetxController {
  late EncuestasSavedController self;
  late TipoEncuesta tipoEncuesta;

  final _authX = Get.find<AuthController>();

  final _encuestasProvider = EncuestasProvider();

  final datetimeFormat = DateFormat('dd/MM/yyyy hh:mm a');

  final gbScaffold = "gbScaffold";
  final gbLista = "gbLista";

  // Cuando se leen registros
  final fetching = true.obs;
  // Cuando se guardan/actualizan registros en SQLite y/o backend
  // Cuando es true, se bloquea la opción de back
  final savingBackend = false.obs;

  // New variables
  final inputSearchCtlr = TextEditingController();
  final searchObs = ''.obs;

  final List<SelectableEntity> allElements = [];
  final List<SelectableEntity> filteredList = [];

  bool isSentViewMode = false;

  @override
  void onInit() {
    super.onInit();
    self = this;

    if (Get.arguments is EncuestasSavedArguments) {
      final arguments = Get.arguments as EncuestasSavedArguments;
      tipoEncuesta = arguments.tipoEncuesta;
    }
    _init();
  }

  @override
  void onClose() {
    inputSearchCtlr.dispose();
    super.onClose();
  }

  void _init() {
    /// Debouncer para detectar el texto ingresado por el usuario
    /// despues de que el usuario dejó de presionar una tecla
    /// por 800 milisegundos.
    debounce(searchObs, (term) {
      _searchByTerm(term);
    }, time: const Duration(milliseconds: 800));

    inputSearchCtlr.addListener(() {
      searchObs.value = inputSearchCtlr.text;
    });

    _fetchList();
  }

  /// Realiza un filtrado de las encuestas buscando el texto ingresado
  /// y comparándolo con el texto del título y subítulo.
  void _searchByTerm(String term) {
    filteredList.clear();

    final foundList = allElements.where((e) =>
        e.title.toLowerCase().contains(term.toLowerCase()) ||
        e.subTitle.toLowerCase().contains(term.toLowerCase()));
    filteredList.addAll(foundList.toList());
    update([gbLista]);
  }

  /// Solicita la lista de encuestas guardas de manera local
  /// en el SQLite según el tipo de encuesta que el usuario haya
  /// seleccionado en la página anterior.
  Future<void> _fetchList() async {
    fetching.value = true;

    await tryCatch(
      code: () async {
        allElements.clear();

        switch (tipoEncuesta.key) {
          case EncuestaKey.cloroResidual:
            await _loadCloroResidualList();
            break;

          case EncuestaKey.componenteSap:
            await _loadComponenteSapList();
            break;

          case EncuestaKey.continuidadServicio:
            await _loadContinuidadServicioList();
            break;

          case EncuestaKey.cloracion:
            await _loadCloracionList();
            break;
        }

        // Extraer funcion
        filteredList.clear();
        filteredList.addAll(allElements);
      },
      onCancelRetry: () async {
        Get.back();
      },
    );

    fetching.value = false;
  }

  Future<void> _loadCloroResidualList() async {
    // Verifica el login para filtrar los enviados por usuario
    String? userFiltered;
    if (isSentViewMode) {
      if (_authX.hasCredentials) {
        userFiltered = _authX.userCredentials?.usuarioAlias ?? '';
      }
    }

    final encuestas = await DBProvider.db.listAllCloroResiduales(
        enviado: isSentViewMode, filterByUser: userFiltered);
    for (var encuesta in encuestas) {
      final centroPoblado =
          await DBProvider.db.listCentroPobladoById(encuesta.centroPobladosId);
      final sap = await DBProvider.db.listSapById(encuesta.sapId);

      /// Agrega la encuesta a una clase superior que permite cambiar el
      /// estado de seleccionado/no seleccionado
      allElements.add(SelectableEntity(
        selected: false,
        title: centroPoblado!.alias,
        subTitle: sap!.alias,
        description: datetimeFormat.format(encuesta.fechaInsitu),
        completo: encuesta.completo,
        enviado: encuesta.enviado,
        entity: encuesta,
        fechaEnviado: encuesta.fechaEnviado,
      ));
    }
  }

  Future<void> _loadComponenteSapList() async {
    // Verifica el login para filtrar los enviados por usuario
    String? userFiltered;
    if (isSentViewMode) {
      if (_authX.hasCredentials) {
        userFiltered = _authX.userCredentials?.usuarioAlias ?? '';
      }
    }

    final encuestas = await DBProvider.db.listAllComponenteSap(
        enviado: isSentViewMode, filterByUser: userFiltered);
    for (var encuesta in encuestas) {
      final centroPoblado =
          await DBProvider.db.listCentroPobladoById(encuesta.centroPobladosId);
      final sap = await DBProvider.db.listSapById(encuesta.sapId);

      /// Agrega la encuesta a una clase superior que permite cambiar el
      /// estado de seleccionado/no seleccionado
      allElements.add(SelectableEntity(
        selected: false,
        title: centroPoblado!.alias,
        subTitle: sap!.alias,
        description: datetimeFormat.format(encuesta.fechaInsitu),
        completo: encuesta.completo,
        enviado: encuesta.enviado,
        entity: encuesta,
        fechaEnviado: encuesta.fechaEnviado,
      ));
    }
  }

  Future<void> _loadContinuidadServicioList() async {
    // Verifica el login para filtrar los enviados por usuario
    String? userFiltered;
    if (isSentViewMode) {
      if (_authX.hasCredentials) {
        userFiltered = _authX.userCredentials?.usuarioAlias ?? '';
      }
    }

    final encuestas = await DBProvider.db.listAllContinuidadServicio(
        enviado: isSentViewMode, filterByUser: userFiltered);
    for (var encuesta in encuestas) {
      final centroPoblado =
          await DBProvider.db.listCentroPobladoById(encuesta.centroPobladosId);
      final sap = await DBProvider.db.listSapById(encuesta.sapId);

      /// Agrega la encuesta a una clase superior que permite cambiar el
      /// estado de seleccionado/no seleccionado
      allElements.add(SelectableEntity(
        selected: false,
        title: centroPoblado!.alias,
        subTitle: sap!.alias,
        description: datetimeFormat.format(encuesta.fechaInsitu),
        completo: encuesta.completo,
        enviado: encuesta.enviado,
        entity: encuesta,
        fechaEnviado: encuesta.fechaEnviado,
      ));
    }
  }

  Future<void> _loadCloracionList() async {
    // Verifica el login para filtrar los enviados por usuario
    String? userFiltered;
    if (isSentViewMode) {
      if (_authX.hasCredentials) {
        userFiltered = _authX.userCredentials?.usuarioAlias ?? '';
      }
    }

    final encuestas = await DBProvider.db.listAllCloraciones(
        enviado: isSentViewMode, filterByUser: userFiltered);
    for (var encuesta in encuestas) {
      final centroPoblado =
          await DBProvider.db.listCentroPobladoById(encuesta.centroPobladosId);
      final sap = await DBProvider.db.listSapById(encuesta.sapId);

      /// Agrega la encuesta a una clase superior que permite cambiar el
      /// estado de seleccionado/no seleccionado
      allElements.add(SelectableEntity(
        selected: false,
        title: centroPoblado!.alias,
        subTitle: sap!.alias,
        description: datetimeFormat.format(encuesta.fechaInsitu),
        completo: encuesta.completo,
        enviado: encuesta.enviado,
        entity: encuesta,
        fechaEnviado: encuesta.fechaEnviado,
      ));
    }
  }

  //****** ITEM LIST METHODS ******/
  void onItemCheckTap(bool value, int index, SelectableEntity item) {
    filteredList[index] = item.copyWith(selected: value);
    update([gbLista]);
  }

  // Verifica que el usuario puede ver o editar la encuesta
  /* bool _canViewOrEdit(int centroId) {
    final result = _authX.userCredentials!.misCentrosPoblados
        .any((e) => e.centroPobladosId == centroId);
    return result;
  } */

  Future<void> onItemTap(int index, SelectableEntity item) async {
    final encuesta = item.entity;

    final tipoEncuestaKey = tipoEncuesta.key;
    dynamic result;
    switch (tipoEncuestaKey) {
      case EncuestaKey.cloroResidual:
        final typedEncuesta = encuesta as CloroResidual;
        result = await Get.toNamed(
          AppRoutes.ENCUESTA_CLORO_RESIDUAL,
          arguments: EncuestaCloroResidualArguments(
            editId: typedEncuesta.cloroResidualesId,
            readOnly: isSentViewMode,
          ),
        );
        break;

      case EncuestaKey.componenteSap:
        final typedEncuesta = encuesta as ComponenteSap;
        result = await Get.toNamed(
          AppRoutes.ENCUESTA_COMPONENTE_SAP,
          arguments: EncuestaComponenteSapArguments(
            editId: typedEncuesta.componentesapId,
            readOnly: isSentViewMode,
          ),
        );
        break;

      case EncuestaKey.continuidadServicio:
        final typedEncuesta = encuesta as ContinuidadServicio;
        result = await Get.toNamed(
          AppRoutes.ENCUESTA_CONTINUIDAD_SERVICIO,
          arguments: EncuestaContinuidadServicioArguments(
            editId: typedEncuesta.continuidadServiciosId,
            readOnly: isSentViewMode,
          ),
        );
        break;

      case EncuestaKey.cloracion:
        final typedEncuesta = encuesta as Cloracion;
        result = await Get.toNamed(
          AppRoutes.ENCUESTA_CLORACION,
          arguments: EncuestaCloracionArguments(
            editId: typedEncuesta.cloracionesId,
            readOnly: isSentViewMode,
          ),
        );
        break;
    }

    if (result is int) _fetchList();
  }

  Future<void> onDeleteItemTap(int index, SelectableEntity item) async {
    final exitAppConfirm = await Helpers.confirmDialog(
      title: '¿Seguro de eliminar el registro?',
      subTitle: 'Esta acción no se puede deshacer',
      yesText: 'Sí, eliminar',
      yesBackgroundColor: akRedColor,
      noText: 'No, cancelar',
    );
    if (exitAppConfirm ?? false) {
      fetching.value = true;
      await tryCatch(code: () async {
        final entity = item.entity;

        if (entity is CloroResidual) {
          await DBProvider.db.deleteCloroResidualById(entity.cloroResidualesId);
        } else if (entity is ComponenteSap) {
          await DBProvider.db.deleteComponenteSapById(entity.componentesapId);
        } else if (entity is ContinuidadServicio) {
          await DBProvider.db
              .deleteContinuidadServicioById(entity.continuidadServiciosId);
        } else if (entity is Cloracion) {
          await DBProvider.db.deleteCloracionById(entity.cloracionesId);
        }

        await Future.delayed(const Duration(milliseconds: 400));
        fetching.value = true;
        await _fetchList();
      });
    }
  }

  /// Limpia el input del autocompletar
  void onCleanInputTap() {
    inputSearchCtlr.clear();
  }

  //****** ACTIONS METHODS ******/
  Future<void> onActionSendTap() async {
    if (!_authX.hasCredentials) {
      AppSnackbar()
          .warning(message: "¡Debe iniciar sesión para efectuar la acción!");
      return;
    }

    /// Filtra las encuestas con el estado completo
    /// Completo es true cuando las propiedades requeridades por el backend
    /// han sido completadas y que las imagenes (obligatorias) fueron adjuntadas
    final prepareList = filteredList.where(
      (e) => e.selected && e.completo && !e.enviado,
    );

    if (prepareList.isEmpty) {
      AppSnackbar()
          .warning(message: "Selecciona al menos una encuesta completa.");
      return;
    }

    savingBackend.value = true;
    await tryCatch(code: () async {
      // Este array almacena el estado de cada proceso
      final List<bool> results = [];
      for (var element in prepareList) {
        final entity = element.entity;

        if (entity is CloroResidual) {
          results.add(await _sentCloroResidualToBackend(entity));
        } else if (entity is ComponenteSap) {
          results.add(await _sentComponenteSapToBackend(entity));
        } else if (entity is ContinuidadServicio) {
          results.add(await _sentContinuidadServicioToBackend(entity));
        } else if (entity is Cloracion) {
          results.add(await _sentCloracionToBackend(entity));
        }
      }

      // Verifica que todo se registró correctamente
      if (results.every((i) => i == true)) {
        AppSnackbar().success(
          message: 'Se registraron todas las encuestas con éxito.',
        );
      } else {
        AppSnackbar().warning(
          message: 'Hubo encuestas que no se registraron exitosamente.',
        );
      }
    });

    savingBackend.value = false;
    _fetchList();
  }

  /// Envía las encustas e imágenes al backend para su sincronización
  Future<bool> _sentCloroResidualToBackend(CloroResidual data) async {
    bool success = false;
    try {
      // Obtiene las imagenes según su encuesta Id
      final images = await DBProvider.db.listImagenCloroResidualByEncuestaId(
        data.cloroResidualesId,
      );
      // Prepara la entidad adjuntando el usuario
      final user = _authX.userCredentials?.usuarioAlias ?? '';
      final localEntity = data.copyWith(
        usuarioRegistro: Wrapped.value(user),
        recolector: Wrapped.value(user),
      );
      // Envia la entidad al servidor y obtiene su id del backend.
      final backendId = await _encuestasProvider.postCloroResidual(localEntity);
      // Adjunta el backendId para poder subir las imagenes
      final backendEntity = localEntity.copyWith(
        backendId: Wrapped.value(backendId),
        fechaEnviado: Wrapped.value(DateTime.now()),
      );
      // Registra las imagenes según su backendId
      await _encuestasProvider.postImagenesCloroResidual(backendEntity, images);
      // Actualiza el estado enviado en el SQLite
      await DBProvider.db.updateCloroResidual(
        backendEntity.copyWith(enviado: const Wrapped.value(true)),
      );
      success = true;
    } catch (e, stackTrace) {
      Helpers.logger.e(e);
      Helpers.logger.e(stackTrace);
    }
    return success;
  }

  /// Envía las encustas e imágenes al backend para su sincronización
  Future<bool> _sentComponenteSapToBackend(ComponenteSap data) async {
    bool success = false;
    try {
      // Obtiene las imagenes según su encuesta Id
      final images = await DBProvider.db.listImagenComponenteSapByEncuestaId(
        data.componentesapId,
      );
      // Prepara la entidad adjuntando el usuario
      final user = _authX.userCredentials?.usuarioAlias ?? '';
      final localEntity = data.copyWith(
        usuarioRegistro: Wrapped.value(user),
        recolector: Wrapped.value(user),
      );
      // Envia la entidad al servidor y obtiene su id del backend.
      final backendId = await _encuestasProvider.postComponenteSap(localEntity);
      // Adjunta el backendId para poder subir las imagenes
      final backendEntity = localEntity.copyWith(
        backendId: Wrapped.value(backendId),
        fechaEnviado: Wrapped.value(DateTime.now()),
      );
      // Registra las imagenes según su backendId
      await _encuestasProvider.postImagenesComponenteSap(backendEntity, images);
      // Actualiza el estado enviado en el SQLite
      await DBProvider.db.updateComponenteSap(
        backendEntity.copyWith(enviado: const Wrapped.value(true)),
      );
      success = true;
    } catch (e, stackTrace) {
      Helpers.logger.e(e);
      Helpers.logger.e(stackTrace);
    }
    return success;
  }

  /// Envía las encustas e imágenes al backend para su sincronización
  Future<bool> _sentContinuidadServicioToBackend(
      ContinuidadServicio data) async {
    bool success = false;
    try {
      // Obtiene las imagenes según su encuesta Id
      final images =
          await DBProvider.db.listImagenContinuidadServicioByEncuestaId(
        data.continuidadServiciosId,
      );
      // Prepara la entidad adjuntando el usuario
      final user = _authX.userCredentials?.usuarioAlias ?? '';
      final localEntity = data.copyWith(
        usuarioRegistro: Wrapped.value(user),
        recolector: Wrapped.value(user),
      );
      // Envia la entidad al servidor y obtiene su id del backend.
      final backendId =
          await _encuestasProvider.postContinuidadServicio(localEntity);
      // Adjunta el backendId para poder subir las imagenes
      final backendEntity = localEntity.copyWith(
        backendId: Wrapped.value(backendId),
        fechaEnviado: Wrapped.value(DateTime.now()),
      );
      // Registra las imagenes según su backendId
      await _encuestasProvider.postImagenesContinuidadServicio(
          backendEntity, images);
      // Actualiza el estado enviado en el SQLite
      await DBProvider.db.updateContinuidadServicio(
        backendEntity.copyWith(enviado: const Wrapped.value(true)),
      );
      success = true;
    } catch (e, stackTrace) {
      Helpers.logger.e(e);
      Helpers.logger.e(stackTrace);
    }
    return success;
  }

  /// Envía las encustas e imágenes al backend para su sincronización
  Future<bool> _sentCloracionToBackend(Cloracion data) async {
    bool success = false;
    try {
      // Obtiene las imagenes según su encuesta Id
      final images = await DBProvider.db.listImagenCloracionByEncuestaId(
        data.cloracionesId,
      );
      // Prepara la entidad adjuntando el usuario
      final user = _authX.userCredentials?.usuarioAlias ?? '';
      final localEntity = data.copyWith(
        usuarioRegistro: Wrapped.value(user),
        recolector: Wrapped.value(user),
      );
      // Envia la entidad al servidor y obtiene su id del backend.
      final backendId = await _encuestasProvider.postCloracion(localEntity);
      // Adjunta el backendId para poder subir las imagenes
      final backendEntity = localEntity.copyWith(
        backendId: Wrapped.value(backendId),
        fechaEnviado: Wrapped.value(DateTime.now()),
      );
      // Registra las imagenes según su backendId
      await _encuestasProvider.postImagenesCloracion(backendEntity, images);
      // Actualiza el estado enviado en el SQLite
      await DBProvider.db.updateCloracion(
        backendEntity.copyWith(enviado: const Wrapped.value(true)),
      );
      success = true;
    } catch (e, stackTrace) {
      Helpers.logger.e(e);
      Helpers.logger.e(stackTrace);
    }
    return success;
  }

  void onActionSelectAllTap() {
    for (var i = 0; i < filteredList.length; i++) {
      filteredList[i] = filteredList[i].copyWith(selected: true);
    }
    update([gbLista]);
  }

  void onActionUnselectAllTap() {
    for (var i = 0; i < filteredList.length; i++) {
      filteredList[i] = filteredList[i].copyWith(selected: false);
    }
    update([gbLista]);
  }

  /// Intercambia la vista entre las encuestas pendientes por enviar
  /// y las encuesta que ya fueron enviadas por un usuario registrado
  void onToggleViewMode() {
    // Verifica que el usuario haya iniciado sesión para mostrar
    // La lista de enviados
    if (!isSentViewMode && (!_authX.hasCredentials)) {
      AppSnackbar()
          .warning(message: "¡Debe iniciar sesión ver la lista de enviados!");
      return;
    }

    isSentViewMode = !isSentViewMode;
    update([gbScaffold]);

    _fetchList();
  }

  /// lógica que evita que el usuario regrese a la pantalla anterior
  /// cuando se está enviando información al backend. De esta forma,
  /// se evita que el proceso se interrumpa
  Future<bool> handleBack() async {
    if (savingBackend.value) {
      AppSnackbar().info(message: 'Por favor, espere...');
      return false;
    }
    return true;
  }

  Future<void> onArrowBackTap() async {
    if (await handleBack()) {
      Get.back();
    }
  }

  /* Future<void> refreshById(int index, int id) async {
    await tryCatch(code: () async {
      switch (tipoEncuesta.key) {
        case EncuestaKey.cloroResidual:
          final encuesta = await DBProvider.db.listCloroResidualById(id);
          filteredList[index] = filteredList[index].copyWith(
            entity: encuesta!,
            completo: encuesta.completo,
          );
          break;

        case EncuestaKey.componenteSap:
          final encuesta = await DBProvider.db.listComponenteSapById(id);
          filteredList[index] = filteredList[index].copyWith(
            entity: encuesta!,
            completo: encuesta.completo,
          );
          break;

        case EncuestaKey.continuidadServicio:
          final encuesta = await DBProvider.db.listContinuidadServicioById(id);
          filteredList[index] = filteredList[index].copyWith(
            entity: encuesta!,
            completo: encuesta.completo,
          );
          break;

        case EncuestaKey.cloracion:
          final encuesta = await DBProvider.db.listCloracionById(id);
          filteredList[index] = filteredList[index].copyWith(
            entity: encuesta!,
            completo: encuesta.completo,
          );
          break;
      }

      update([gbLista]);
    });
  } */
}

class EncuestasSavedArguments {
  final TipoEncuesta tipoEncuesta;
  const EncuestasSavedArguments({required this.tipoEncuesta});
}
