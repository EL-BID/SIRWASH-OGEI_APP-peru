import 'dart:io';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sirwash/data/models/models.dart';
import 'package:sirwash/data/providers/db_provider.dart';
import 'package:sirwash/modules/auth/auth_controller.dart';
import 'package:sirwash/modules/form_map_wrapper/form_map_wrapper_controller.dart';
import 'package:sirwash/utils/utils.dart';
import 'package:sirwash/widgets/widgets.dart';
import 'package:uuid/uuid.dart';

import '../helpers/helpers.dart';

class EncuestaComponenteSapController extends GetxController {
  late FormMapWrapperController wrapperX;
  final _authX = Get.find<AuthController>();

  final uuid = const Uuid();

  final gbBody = 'gbBody';
  final gbPhotos = 'gbPhotos';

  bool loadingForm = true;

  double _latitude = 0.0;
  double _longitude = 0.0;

  final formKey = GlobalKey<FormState>();

  List<CentroPoblado> listCentrosPoblados = [];
  CentroPoblado? selectedCentroPoblado;

  List<Sap> listSap = [];
  Sap? selectedSap;

  List<Prestador> listPrestadores = [];
  Prestador? selectedPrestador;

  final centroPobladoDropdownKey =
      GlobalKey<DropdownSearchState<CentroPoblado>>();
  final sapDropdownKey = GlobalKey<DropdownSearchState<Sap>>();
  final prestadorDropdownKey = GlobalKey<DropdownSearchState<Prestador>>();

  final loadingCentroList = false.obs;
  final loadingSapList = false.obs;
  final loadingPrestadorList = false.obs;

  final calcloradaCtlr = TextEditingController();

  final hipocloritoInRange = false.obs;

  List<TipoImagen> tiposImagen = [];
  List<PhotoFile> photos = [];

  int? editId;
  bool isReadOnly = false;

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments is EncuestaComponenteSapArguments) {
      final arguments = Get.arguments as EncuestaComponenteSapArguments;
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
    // Hipoclorito de Calcio
    calcloradaCtlr.addListener(() {
      if (calcloradaCtlr.text.isNotEmpty) {
        final value = double.parse(calcloradaCtlr.text);
        hipocloritoInRange.value = value >= 0.5 && value <= 4;
      } else {
        hipocloritoInRange.value = false;
      }
    });
  }

  @override
  void onClose() {
    calcloradaCtlr.dispose();
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

        // Si es usuario registrado, filtra solo sus centros poblados asignados
        final Future futureCentros = _authX.hasCredentials
            ? DBProvider.db.listAllCentroPobladoInArray(
                _authX.userCredentials!.misCentrosPoblados)
            : DBProvider.db.listAllCentroPoblado();

        final arrayData = await Future.wait([
          DBProvider.db.listAllTipoImagenByGrupo('COMPONENTE_SAP'),
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
        final encuesta = await DBProvider.db.listComponenteSapById(id);
        _latitude = encuesta!.latitud;
        _longitude = encuesta.longitud;
        if (isReadOnly) {
          wrapperX.addUniqueMarker(_latitude, _longitude);
          wrapperX.jumpTo(_latitude, _longitude);
          wrapperX.forceSetLatLngLabels(_latitude, _longitude);
        }

        // Obtiene la lista de imagenes
        final storeImages = await DBProvider.db
            .listImagenComponenteSapByEncuestaId(encuesta.componentesapId);
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

        calcloradaCtlr.text = encuesta.hipoclorito?.toString() ?? '';

        if (encuesta.prestadoresId != null) {
          final prestador =
              await DBProvider.db.listPrestadorById(encuesta.prestadoresId!);
          // Delay importante que espera la búsqueda del prestador
          await Future.delayed(const Duration(seconds: 1));
          prestadorDropdownKey.currentState?.changeSelectedItem(prestador);
        }
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

    // Limpia el valor anidado
    prestadorDropdownKey.currentState?.changeSelectedItem(null);
    // Limpia las lista anidada
    listPrestadores = [];
    update([gbBody]);
    await tryCatch(code: () async {
      if (selected == null) return;
      loadingPrestadorList.value = true;
      listPrestadores = await DBProvider.db.listPrestadorByCodCentroPoblado(
        selected.codigoCentroPoblados,
      );
      loadingPrestadorList.value = false;
      update([gbBody]);
    });
  }

  Future<void> setPrestadorSelected(Prestador? selected) async {
    selectedPrestador = selected;

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
      final form = ComponenteSap(
        componentesapId: editId ?? await DBProvider.db.getNewIdComponenteSap(),
        hipoclorito: Helpers.toDoubleOrNull(calcloradaCtlr.text),
        fechaInsitu: DateTime.now(),
        recolector: null,
        validado: null,
        latitud: _latitude,
        longitud: _longitude,
        centroPobladosId: selectedCentroPoblado!.centroPobladosId,
        sapId: selectedSap!.sapId,
        prestadoresId: selectedPrestador?.prestadoresId,
        historial: null,
        usuarioRegistro: null,
        completo: false,
        enviado: false,
      );

      final isFormCompleted = ComponenteSap.isCompleteForBackend(form);
      final imagesCompleted = checkPhotosCompleted(tiposImagen, photos);

      bool prestadorCompleted = true;
      if (listPrestadores.isNotEmpty && selectedPrestador == null) {
        prestadorCompleted = false;
      }

      final checkedForm = form.copyWith(
        completo: Wrapped.value(
            isFormCompleted && prestadorCompleted && imagesCompleted),
      );

      // Inicia funcion
      await Future.delayed(const Duration(seconds: 1));
      if (editId != null) {
        await DBProvider.db.updateComponenteSap(checkedForm);
      } else {
        await DBProvider.db.insertComponenteSap(checkedForm);
      }

      // Elimina todas las imagenes asociadas a la encuesta
      await DBProvider.db.deleteAllImagenComponenteSapByEncuestaId(
        checkedForm.componentesapId,
      );
      // Añade las imagenes en la tabla de relacion
      for (var photo in photos) {
        final tempPhoto = RelComponenteSapTipoImagen(
          imagenId: await DBProvider.db.getNewIdImagenComponenteSap(),
          nombre: photo.name,
          ruta: photo.file.path,
          tipoImagenId: photo.tipoImagenId,
          fechaInsitu: DateTime.now(),
          componenteSapId: checkedForm.componentesapId,
          usuarioRegistro: null,
          latitud: photo.latitude,
          longitud: photo.longitude,
        );
        await DBProvider.db.insertImagenComponenteSap(tempPhoto);
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

class EncuestaComponenteSapArguments {
  final int? editId;
  final bool readOnly;
  const EncuestaComponenteSapArguments({this.editId, this.readOnly = false});
}
