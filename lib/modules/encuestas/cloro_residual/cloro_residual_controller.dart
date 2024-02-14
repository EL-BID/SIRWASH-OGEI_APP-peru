import 'dart:io';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:sirwash/data/models/models.dart';
import 'package:sirwash/data/providers/db_provider.dart';
import 'package:sirwash/modules/auth/auth_controller.dart';
import 'package:sirwash/modules/encuestas/helpers/helpers.dart';
import 'package:sirwash/modules/form_map_wrapper/form_map_wrapper_controller.dart';
import 'package:sirwash/utils/utils.dart';
import 'package:sirwash/widgets/widgets.dart';
import 'package:uuid/uuid.dart';

class EncuestaCloroResidualController extends GetxController {
  late FormMapWrapperController wrapperX;
  final _authX = Get.find<AuthController>();

  final uuid = const Uuid();

  final gbBody = 'gbBody';
  final gbExtraInputs = 'gbExtraInputs';
  final gbPhotos = 'gbPhotos';

  bool loadingForm = true;

  double _latitude = 0.0;
  double _longitude = 0.0;

  final formKey = GlobalKey<FormState>();

  List<CentroPoblado> listCentrosPoblados = [];
  CentroPoblado? selectedCentroPoblado;

  List<Sap> listSap = [];
  Sap? selectedSap;

  final centroPobladoDropdownKey =
      GlobalKey<DropdownSearchState<CentroPoblado>>();
  final sapDropdownKey = GlobalKey<DropdownSearchState<Sap>>();

  final loadingCentroList = false.obs;
  final loadingSapList = false.obs;

  bool isVisibleExtraInputs = false;

  final reservorioDateTime = ValueNotifier<DateTime?>(null);
  final reservorioFechaCtlr = TextEditingController();
  final reservorioValorCtlr = TextEditingController();
  final reservorioInRange = false.obs;

  final primeraViviendaDateTime = ValueNotifier<DateTime?>(null);
  final primeraViviendaFechaCtlr = TextEditingController();
  final primeraViviendaValorCtlr = TextEditingController();
  final primeraViviendaInRange = false.obs;
  final primeraViviendaDniCtlr = TextEditingController();

  final viviendaIntermediaDateTime = ValueNotifier<DateTime?>(null);
  final viviendaIntermediaFechaCtlr = TextEditingController();
  final viviendaIntermediaValorCtlr = TextEditingController();
  final viviendaIntermediaInRange = false.obs;
  final viviendaIntermediaDniCtlr = TextEditingController();

  final ultimaViviendaDateTime = ValueNotifier<DateTime?>(null);
  final ultimaViviendaFechaCtlr = TextEditingController();
  final ultimaViviendaValorCtlr = TextEditingController();
  final ultimaViviendaInRange = false.obs;
  final ultimaViviendaDniCtlr = TextEditingController();

  List<TipoImagen> tiposImagen = [];
  List<PhotoFile> photos = [];

  int? editId;
  bool isReadOnly = false;

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments is EncuestaCloroResidualArguments) {
      final arguments = Get.arguments as EncuestaCloroResidualArguments;
      editId = arguments.editId;
      isReadOnly = arguments.readOnly;
    } else {
      throw Exception('Params must be send');
    }

    _setListeners();

    /// Inyecta el controlador del Wrapper
    wrapperX = Get.put(
      FormMapWrapperController(
        disableStreamPosition: isReadOnly,
        onPositionFound: _onUserPositionFound,
        onMapsReady: _init,
        backLogic: handleBack,
      ),
    );
  }

  void _setListeners() {
    final dateFormat = DateFormat('dd/MM/yyyy hh:mma');
    // Reservorio listeners
    reservorioDateTime.addListener(() {
      if (reservorioDateTime.value != null) {
        reservorioFechaCtlr.text =
            (dateFormat.format(reservorioDateTime.value!)).toLowerCase();
      }
    });
    reservorioValorCtlr.addListener(() {
      if (reservorioValorCtlr.text.isNotEmpty) {
        final value = double.parse(reservorioValorCtlr.text);
        reservorioInRange.value = value >= 0.5 && value <= 2;
      } else {
        reservorioInRange.value = false;
      }
    });

    // Primera Vivienda listeners
    primeraViviendaDateTime.addListener(() {
      if (primeraViviendaDateTime.value != null) {
        primeraViviendaFechaCtlr.text =
            (dateFormat.format(primeraViviendaDateTime.value!)).toLowerCase();
      }
    });
    primeraViviendaValorCtlr.addListener(() {
      if (primeraViviendaValorCtlr.text.isNotEmpty) {
        final value = double.parse(primeraViviendaValorCtlr.text);
        primeraViviendaInRange.value = value >= 0.5 && value <= 1.2;
      } else {
        primeraViviendaInRange.value = false;
      }
    });

    // Vivienda Intermedia listeners
    viviendaIntermediaDateTime.addListener(() {
      if (viviendaIntermediaDateTime.value != null) {
        viviendaIntermediaFechaCtlr.text =
            (dateFormat.format(viviendaIntermediaDateTime.value!))
                .toLowerCase();
      }
    });
    viviendaIntermediaValorCtlr.addListener(() {
      if (viviendaIntermediaValorCtlr.text.isNotEmpty) {
        final value = double.parse(viviendaIntermediaValorCtlr.text);
        viviendaIntermediaInRange.value = value >= 0.5 && value <= 0.8;
      } else {
        viviendaIntermediaInRange.value = false;
      }
    });

    // Última Vivienda listeners
    ultimaViviendaDateTime.addListener(() {
      if (ultimaViviendaDateTime.value != null) {
        ultimaViviendaFechaCtlr.text =
            (dateFormat.format(ultimaViviendaDateTime.value!)).toLowerCase();
      }
    });
    ultimaViviendaValorCtlr.addListener(() {
      if (ultimaViviendaValorCtlr.text.isNotEmpty) {
        final value = double.parse(ultimaViviendaValorCtlr.text);
        ultimaViviendaInRange.value = value >= 0.5 && value <= 0.7;
      } else {
        ultimaViviendaInRange.value = false;
      }
    });
  }

  @override
  void onClose() {
    reservorioDateTime.dispose();
    reservorioValorCtlr.dispose();

    primeraViviendaDateTime.dispose();
    primeraViviendaValorCtlr.dispose();

    viviendaIntermediaDateTime.dispose();
    viviendaIntermediaValorCtlr.dispose();

    ultimaViviendaDateTime.dispose();
    ultimaViviendaValorCtlr.dispose();
    super.onClose();
  }

  void _onUserPositionFound(Position position) {
    if (!isReadOnly) {
      _latitude = position.latitude;
      _longitude = position.longitude;
    }
  }

  Future<void> _init() async {
    _setLoadingForm(true);
    await tryCatch(
      code: () async {
        // Si es un registro nuevo, completa las fechas por defecto
        // Más adelante, al momento de guardar, tomará la fecha exacta
        if (editId == null) {
          final now = DateTime.now();
          reservorioDateTime.value = now;
          primeraViviendaDateTime.value = now;
          viviendaIntermediaDateTime.value = now;
          ultimaViviendaDateTime.value = now;
        }

        loadingCentroList.value = true;

        // Si es usuario registrado, filtra solo sus centros poblados asignados
        final Future futureCentros = _authX.hasCredentials
            ? DBProvider.db.listAllCentroPobladoInArray(
                _authX.userCredentials!.misCentrosPoblados)
            : DBProvider.db.listAllCentroPoblado();

        final arrayData = await Future.wait([
          DBProvider.db.listAllTipoImagenByGrupo('CLORO_RESIDUAL'),
          futureCentros,
        ]);

        tiposImagen = arrayData[0] as List<TipoImagen>;
        listCentrosPoblados = arrayData[1] as List<CentroPoblado>;

        loadingCentroList.value = false;

        // Verifica que no haya errores, de lo contrario sale de la encuesta
        final errorMsg = erroresListCentroPoblado(_authX, listCentrosPoblados);
        if (errorMsg?.isNotEmpty ?? false) {
          await Future.delayed(const Duration(seconds: 1));
          Get.back();
          AppSnackbar().warning(message: errorMsg!);
          return;
        }

        if (editId != null) {
          await _loadEditDataById(editId!);
        }
      },
      onCancelRetry: () async => Get.back(),
    );
    _setLoadingForm(false, updatePanel: true);
  }

  Future<void> _loadEditDataById(int id) async {
    await tryCatch(
      code: () async {
        final encuesta = await DBProvider.db.listCloroResidualById(id);
        _latitude = encuesta!.latitud;
        _longitude = encuesta.longitud;
        if (isReadOnly) {
          wrapperX.addUniqueMarker(_latitude, _longitude);
          wrapperX.jumpTo(_latitude, _longitude);
          wrapperX.forceSetLatLngLabels(_latitude, _longitude);
        }

        // Obtiene la lista de imagenes
        final storeImages = await DBProvider.db
            .listImagenCloroResidualByEncuestaId(encuesta.cloroResidualesId);
        for (var storeImage in storeImages) {
          // Comprueba que aún existan antes de agregarlas
          final existsFile = File(storeImage.ruta).existsSync();
          if (existsFile) {
            final namedFile = PhotoFile(
              uuid: uuid.v4(),
              name: storeImage.nombre,
              tipoImagenId: storeImage.tipoImagenId,
              file: File(storeImage.ruta),
              latitude: storeImage.latitud,
              longitude: storeImage.longitud,
            );
            photos.add(namedFile);
          }
        }

        final centroPoblado = listCentrosPoblados.firstWhereOrNull(
            (e) => e.centroPobladosId == encuesta.centroPobladosId);
        centroPobladoDropdownKey.currentState!
            .changeSelectedItem(centroPoblado);

        final sap = await DBProvider.db.listSapById(encuesta.sapId);
        sapDropdownKey.currentState!.changeSelectedItem(sap);

        reservorioDateTime.value = encuesta.reservorioFecha;
        reservorioValorCtlr.text = encuesta.reservorioCloro?.toString() ?? '';

        primeraViviendaDateTime.value = encuesta.primeraViviendaFecha;
        primeraViviendaValorCtlr.text =
            encuesta.primeraViviendaCloro?.toString() ?? '';
        primeraViviendaDniCtlr.text =
            encuesta.primeraViviendaDni?.toString() ?? '';

        viviendaIntermediaDateTime.value = encuesta.viviendaIntermediaFecha;
        viviendaIntermediaValorCtlr.text =
            encuesta.viviendaIntermediaCloro?.toString() ?? '';
        viviendaIntermediaDniCtlr.text =
            encuesta.viviendaIntermediaDni?.toString() ?? '';

        ultimaViviendaDateTime.value = encuesta.ultimaViviendaFecha;
        ultimaViviendaValorCtlr.text =
            encuesta.ultimaViviendaCloro?.toString() ?? '';
        ultimaViviendaDniCtlr.text =
            encuesta.ultimaViviendaDni?.toString() ?? '';
      },
      onCancelRetry: () async => Get.back(),
    );
  }

  Future<void> _setLoadingForm(bool val, {bool updatePanel = false}) async {
    loadingForm = val;
    update([gbBody]);

    if (updatePanel) {
      await Future.delayed(const Duration(milliseconds: 100));
      wrapperX.forceUpdatePanel();
    }
  }

  // ***********************************
  // ********* INPUTS METHODS **********
  Future<void> setCentroPobladoSelected(CentroPoblado? selected) async {
    selectedCentroPoblado = selected;

    // Limpia el valor anidado
    sapDropdownKey.currentState?.changeSelectedItem(null);
    // Limpia las lista anidada
    listSap = [];
    update([gbBody]);
    await tryCatch(code: () async {
      if (selected == null) return;
      loadingSapList.value = true;
      listSap = await DBProvider.db.listSapByCodCentroPoblado(
        selected.codigoCentroPoblados,
      );
      loadingSapList.value = false;
      update([gbBody]);
    });
  }

  Future<void> setSAPSelected(Sap? selected) async {
    selectedSap = selected;

    await _checkIfExtraInputsIsVisible();
  }

  Future<void> _checkIfExtraInputsIsVisible() async {
    isVisibleExtraInputs = selectedSap != null;
    update([gbExtraInputs]);
    // Wait for widgets to display and reload panel
    await Future.delayed(const Duration(milliseconds: 100));
    wrapperX.forceUpdatePanel();
  }

  // ***********************************
  // ********* SUBMIT METHODS **********
  Future<void> onSubmit() async {
    if (loadingForm) return;

    if (!formKey.currentState!.validate()) {
      AppSnackbar().warning(message: 'Completar los campos obligatorios');
      return;
    }

    _setLoadingForm(true);
    await tryCatch(code: () async {
      // Solo si es registro nuevo, reemplaza las fechas para que tome el momento exacto
      // en que se guarda la encuesta
      if (editId == null) {
        final now = DateTime.now();
        reservorioDateTime.value = now;
        primeraViviendaDateTime.value = now;
        viviendaIntermediaDateTime.value = now;
        ultimaViviendaDateTime.value = now;
      }

      final form = CloroResidual(
        cloroResidualesId:
            editId ?? await DBProvider.db.getNewIdCloroResidual(),
        reservorioCloro: Helpers.toDoubleOrNull(reservorioValorCtlr.text),
        reservorioFecha: reservorioDateTime.value,
        primeraViviendaCloro:
            Helpers.toDoubleOrNull(primeraViviendaValorCtlr.text),
        primeraViviendaFecha: primeraViviendaDateTime.value,
        primeraViviendaDni: primeraViviendaDniCtlr.text,
        viviendaIntermediaCloro:
            Helpers.toDoubleOrNull(viviendaIntermediaValorCtlr.text),
        viviendaIntermediaFecha: viviendaIntermediaDateTime.value,
        viviendaIntermediaDni: viviendaIntermediaDniCtlr.text,
        ultimaViviendaCloro:
            Helpers.toDoubleOrNull(ultimaViviendaValorCtlr.text),
        ultimaViviendaFecha: ultimaViviendaDateTime.value,
        ultimaViviendaDni: ultimaViviendaDniCtlr.text,
        fechaInsitu: DateTime.now(),
        recolector: null,
        latitud: _latitude,
        longitud: _longitude,
        centroPobladosId: selectedCentroPoblado!.centroPobladosId,
        sapId: selectedSap!.sapId,
        validado: null,
        historial: null,
        usuarioRegistro: null,
        completo: false,
        enviado: false,
      );

      final isFormCompleted = CloroResidual.isCompleteForBackend(form);
      final imagesCompleted = checkPhotosCompleted(tiposImagen, photos);

      final checkedForm = form.copyWith(
        completo: Wrapped.value(isFormCompleted && imagesCompleted),
      );

      await Future.delayed(const Duration(seconds: 1));
      if (editId != null) {
        await DBProvider.db.updateCloroResidual(checkedForm);
      } else {
        await DBProvider.db.insertCloroResidual(checkedForm);
      }

      // Elimina todas las imagenes asociadas a la encuesta
      await DBProvider.db.deleteAllImagenCloroResidualByEncuestaId(
        checkedForm.cloroResidualesId,
      );
      // Añade las imagenes en la tabla de relacion
      for (var photo in photos) {
        final tempPhoto = RelCloroResidualTipoImagen(
          imagenId: await DBProvider.db.getNewIdImagenCloroResidual(),
          nombre: photo.name,
          ruta: photo.file.path,
          tipoImagenId: photo.tipoImagenId,
          fechaInsitu: DateTime.now(),
          cloroResidualesId: checkedForm.cloroResidualesId,
          usuarioRegistro: null,
          latitud: photo.latitude,
          longitud: photo.longitude,
        );
        await DBProvider.db.insertImagenCloroResidual(tempPhoto);
      }

      Get.back(result: editId);
      AppSnackbar().success(message: 'Formulario guardado!');
    });
    _setLoadingForm(false);
  }

  Future<bool> handleBack() async {
    if (loadingForm) {
      return false;
    }

    if (isReadOnly) {
      return true;
    } else {
      return await confirmBackWithoutSave();
    }
  }

  Future<void> onCancelButtonTap() async {
    if (await handleBack()) {
      Get.back();
    }
  }

  // ***********************************
  // ********* FILE METHODS **********
  Future<void> onFilePicked(XFile image, int tipoImagenId) async {
    try {
      final namedFile = PhotoFile(
        uuid: uuid.v4(),
        name: image.name,
        tipoImagenId: tipoImagenId,
        file: File(image.path),
        latitude: _latitude,
        longitude: _longitude,
      );

      photos.add(namedFile);
      update([gbPhotos]);
    } catch (e) {
      Helpers.logger.e('No se pudo agregar la foto');
    }
  }

  Future<void> onRemoveFileTap(PhotoFile photo) async {
    final idx = photos.indexWhere((p) => p.uuid == photo.uuid);
    photos.removeAt(idx);
    update([gbPhotos]);
  }
}

class EncuestaCloroResidualArguments {
  final int? editId;
  final bool readOnly;
  const EncuestaCloroResidualArguments({this.editId, this.readOnly = false});
}
