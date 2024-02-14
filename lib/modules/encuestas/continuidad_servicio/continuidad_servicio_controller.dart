import 'dart:io';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sirwash/data/models/models.dart';
import 'package:sirwash/data/providers/db_provider.dart';
import 'package:sirwash/modules/auth/auth_controller.dart';
import 'package:sirwash/modules/encuestas/helpers/helpers.dart';
import 'package:sirwash/utils/utils.dart';
import 'package:sirwash/widgets/widgets.dart';
import 'package:uuid/uuid.dart';

import '../../form_map_wrapper/form_map_wrapper_controller.dart';

class EncuestaContinuidadServicioController extends GetxController {
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

  List<Frecuencia> listFrecuencias = [];
  Frecuencia? selectedFrecuencia;

  List<Hora> listHoras = [];
  Hora? selectedHora;

  List<CaudalAgua> listCaudalAgua = [];
  CaudalAgua? selectedCaudalAgua;

  final centroPobladoDropdownKey =
      GlobalKey<DropdownSearchState<CentroPoblado>>();
  final sapDropdownKey = GlobalKey<DropdownSearchState<Sap>>();
  final frecuenciaDropdownKey = GlobalKey<DropdownSearchState<Frecuencia>>();
  final horaDropdownKey = GlobalKey<DropdownSearchState<Hora>>();
  final caudalAguaDropdownKey = GlobalKey<DropdownSearchState<CaudalAgua>>();

  final loadingCentroList = false.obs;
  final loadingSapList = false.obs;
  final loadingFrecuenciaList = false.obs;
  final loadingHoraList = false.obs;
  final loadingCaudalList = false.obs;

  bool isVisibleExtraInputs = false;

  final tiempo1Ctlr = TextEditingController();
  final tiempo2Ctlr = TextEditingController();
  final tiempo3Ctlr = TextEditingController();

  final RxDouble resultadoPromedio = 0.0.obs;

  List<TipoImagen> tiposImagen = [];
  List<PhotoFile> photos = [];

  int? editId;
  bool isReadOnly = false;

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments is EncuestaContinuidadServicioArguments) {
      final arguments = Get.arguments as EncuestaContinuidadServicioArguments;
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
    // Tiempos
    tiempo1Ctlr.addListener(_calcularTiempoPromedio);
    tiempo2Ctlr.addListener(_calcularTiempoPromedio);
    tiempo3Ctlr.addListener(_calcularTiempoPromedio);
  }

  @override
  void onClose() {
    tiempo1Ctlr.dispose();
    tiempo2Ctlr.dispose();
    tiempo3Ctlr.dispose();
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
        loadingCentroList.value = true;
        loadingFrecuenciaList.value = true;
        loadingHoraList.value = true;
        loadingCaudalList.value = true;

        // Si es usuario registrado, filtra solo sus centros poblados asignados
        final Future futureCentros = _authX.hasCredentials
            ? DBProvider.db.listAllCentroPobladoInArray(
                _authX.userCredentials!.misCentrosPoblados)
            : DBProvider.db.listAllCentroPoblado();

        final arrayData = await Future.wait([
          DBProvider.db.listAllTipoImagenByGrupo('CONTINUIDAD_SERVICIO'),
          futureCentros,
          DBProvider.db.listAllFrecuencias(),
          DBProvider.db.listAllHoras(),
          DBProvider.db.listAllCaudalAguas(),
        ]);

        tiposImagen = arrayData[0] as List<TipoImagen>;
        listCentrosPoblados = arrayData[1] as List<CentroPoblado>;
        listFrecuencias = arrayData[2] as List<Frecuencia>;
        listHoras = arrayData[3] as List<Hora>;
        listCaudalAgua = arrayData[4] as List<CaudalAgua>;

        loadingCentroList.value = false;
        loadingFrecuenciaList.value = false;
        loadingHoraList.value = false;
        loadingCaudalList.value = false;

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
        final encuesta = await DBProvider.db.listContinuidadServicioById(id);
        _latitude = encuesta!.latitud;
        _longitude = encuesta.longitud;
        if (isReadOnly) {
          wrapperX.addUniqueMarker(_latitude, _longitude);
          wrapperX.jumpTo(_latitude, _longitude);
          wrapperX.forceSetLatLngLabels(_latitude, _longitude);
        }

        // Obtiene la lista de imagenes
        final storeImages = await DBProvider.db
            .listImagenContinuidadServicioByEncuestaId(
                encuesta.continuidadServiciosId);
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

        final frecuencia = listFrecuencias
            .firstWhereOrNull((e) => e.frecuenciasId == encuesta.frecuenciasId);
        frecuenciaDropdownKey.currentState!.changeSelectedItem(frecuencia);

        final hora =
            listHoras.firstWhereOrNull((e) => e.horasId == encuesta.horasId);
        horaDropdownKey.currentState!.changeSelectedItem(hora);

        final caudalAgua = listCaudalAgua
            .firstWhereOrNull((e) => e.caudalAguasId == encuesta.caudalAguasId);
        caudalAguaDropdownKey.currentState!.changeSelectedItem(caudalAgua);

        tiempo1Ctlr.text = encuesta.caudalTiempo1?.toString() ?? '';
        tiempo2Ctlr.text = encuesta.caudalTiempo2?.toString() ?? '';
        tiempo3Ctlr.text = encuesta.caudalTiempo3?.toString() ?? '';
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

  void _calcularTiempoPromedio() {
    try {
      final double valorBalde = selectedCaudalAgua?.valor.toDouble() ?? 0.0;

      final tiempo1 =
          tiempo1Ctlr.text.isNotEmpty ? double.parse(tiempo1Ctlr.text) : 0.0;
      final tiempo2 =
          tiempo2Ctlr.text.isNotEmpty ? double.parse(tiempo2Ctlr.text) : 0.0;
      final tiempo3 =
          tiempo3Ctlr.text.isNotEmpty ? double.parse(tiempo3Ctlr.text) : 0.0;

      final promedioTiempos = (tiempo1 + tiempo2 + tiempo3) / 3;

      if (promedioTiempos == 0) {
        // Evitamos que el denominador sea 0
        resultadoPromedio.value = valorBalde;
      } else {
        resultadoPromedio.value = valorBalde / promedioTiempos;
      }
    } catch (e) {
      AppSnackbar().error(message: 'Error calculando el promedio');
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
  }

  Future<void> setFrecuenciaSelected(Frecuencia? selected) async {
    selectedFrecuencia = selected;
  }

  Future<void> setHoraSelected(Hora? selected) async {
    selectedHora = selected;
  }

  Future<void> setCaudalAguaSelected(CaudalAgua? selected) async {
    selectedCaudalAgua = selected;

    tiempo1Ctlr.clear();
    tiempo2Ctlr.clear();
    tiempo3Ctlr.clear();

    await _checkIfExtraInputsIsVisible();
  }

  Future<void> _checkIfExtraInputsIsVisible() async {
    isVisibleExtraInputs = selectedCaudalAgua != null;
    update([gbExtraInputs]);
  }

  // ***********************************
  // ********* INPUTS METHODS **********
  Future<void> onSubmit() async {
    if (loadingForm) return;

    if (!formKey.currentState!.validate()) {
      AppSnackbar().warning(message: 'Completar los campos obligatorios');
      return;
    }

    _setLoadingForm(true);
    await tryCatch(code: () async {
      final form = ContinuidadServicio(
        continuidadServiciosId:
            editId ?? await DBProvider.db.getNewIdContinuidadServicio(),
        caudalTiempo1: Helpers.toDoubleOrNull(tiempo1Ctlr.text),
        caudalTiempo2: Helpers.toDoubleOrNull(tiempo2Ctlr.text),
        caudalTiempo3: Helpers.toDoubleOrNull(tiempo3Ctlr.text),
        fechaInsitu: DateTime.now(),
        recolector: null,
        validado: null,
        latitud: _latitude,
        longitud: _longitude,
        centroPobladosId: selectedCentroPoblado!.centroPobladosId,
        sapId: selectedSap!.sapId,
        frecuenciasId: selectedFrecuencia?.frecuenciasId,
        horasId: selectedHora?.horasId,
        caudalAguasId: selectedCaudalAgua?.caudalAguasId,
        historial: null,
        usuarioRegistro: null,
        completo: false,
        enviado: false,
      );

      final isFormCompleted = ContinuidadServicio.isCompleteForBackend(form);
      final imagesCompleted = checkPhotosCompleted(tiposImagen, photos);

      final checkedForm = form.copyWith(
        completo: Wrapped.value(isFormCompleted && imagesCompleted),
      );

      await Future.delayed(const Duration(seconds: 1));
      if (editId != null) {
        await DBProvider.db.updateContinuidadServicio(checkedForm);
      } else {
        await DBProvider.db.insertContinuidadServicio(checkedForm);
      }

      // Elimina todas las imagenes asociadas a la encuesta
      await DBProvider.db.deleteAllImagenContinuidadServicioByEncuestaId(
        checkedForm.continuidadServiciosId,
      );
      // Añade las imagenes en la tabla de relacion
      for (var photo in photos) {
        final tempPhoto = RelContinuidadServicioTipoImagen(
          imagenId: await DBProvider.db.getNewIdImagenContinuidadServicio(),
          nombre: photo.name,
          ruta: photo.file.path,
          tipoImagenId: photo.tipoImagenId,
          fechaInsitu: DateTime.now(),
          continuidadServicioId: checkedForm.continuidadServiciosId,
          usuarioRegistro: null,
          latitud: photo.latitude,
          longitud: photo.longitude,
        );
        await DBProvider.db.insertImagenContinuidadServicio(tempPhoto);
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

class EncuestaContinuidadServicioArguments {
  final int? editId;
  final bool readOnly;
  const EncuestaContinuidadServicioArguments(
      {this.editId, this.readOnly = false});
}
