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
import 'package:sirwash/modules/form_map_wrapper/form_map_wrapper_controller.dart';
import 'package:sirwash/utils/utils.dart';
import 'package:sirwash/widgets/widgets.dart';
import 'package:uuid/uuid.dart';

class EncuestaCloracionController extends GetxController {
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

  List<Componente> listComponentes = [];
  Componente? selectedComponente;

  List<Insumo> listInsumos = [];
  Insumo? selectedInsumo;

  List<MedidaGas> listGas = [];
  MedidaGas? selectedGas;

  List<MedidaHipocloritos> listHipocloritoSodio = [];
  MedidaHipocloritos? selectedHipocloritoSodio;

  List<MedidaBriqueta> listBriquetas = [];
  MedidaBriqueta? selectedBriqueta;

  final centroPobladoDropdownKey =
      GlobalKey<DropdownSearchState<CentroPoblado>>();
  final sapDropdownKey = GlobalKey<DropdownSearchState<Sap>>();
  final componenteDropdownKey = GlobalKey<DropdownSearchState<Componente>>();
  final insumoDropdownKey = GlobalKey<DropdownSearchState<Insumo>>();
  final gasDropdownKey = GlobalKey<DropdownSearchState<MedidaGas>>();
  final hipoSodioDropdownKey =
      GlobalKey<DropdownSearchState<MedidaHipocloritos>>();
  final briquetaDropdownKey = GlobalKey<DropdownSearchState<MedidaBriqueta>>();

  final loadingCentroList = false.obs;
  final loadingSapList = false.obs;
  final loadingComponentesList = false.obs;
  final loadingInsumosList = false.obs;
  final loadingGasList = false.obs;
  final loadingHipoSodioList = false.obs;
  final loadingBriquetaList = false.obs;

  final selectedCalibracion = false.obs;

  InsumoExtraInputs extraInputsSelected = InsumoExtraInputs.none;

  final valorInsumoCtlr = TextEditingController();
  final solucionMadreCtlr = TextEditingController();

  final valorHipocalcioInRange = false.obs;
  final solucionMadreInRange = false.obs;

  List<TipoImagen> tiposImagen = [];
  List<PhotoFile> photos = [];

  int? editId;
  bool isReadOnly = false;

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments is EncuestaCloracionArguments) {
      final arguments = Get.arguments as EncuestaCloracionArguments;
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
    // Valor Hipocalcio
    valorInsumoCtlr.addListener(() {
      if (valorInsumoCtlr.text.isNotEmpty) {
        final value = double.parse(valorInsumoCtlr.text);
        valorHipocalcioInRange.value = value >= 0.5 && value <= 5.5;
      } else {
        valorHipocalcioInRange.value = false;
      }
    });

    // Solución madre
    solucionMadreCtlr.addListener(() {
      if (solucionMadreCtlr.text.isNotEmpty) {
        final value = double.parse(solucionMadreCtlr.text);
        solucionMadreInRange.value = value >= 0.5 && value <= 5.5;
      } else {
        solucionMadreInRange.value = false;
      }
    });
  }

  @override
  void onClose() {
    valorInsumoCtlr.dispose();
    solucionMadreCtlr.dispose();
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
        loadingComponentesList.value = true;
        loadingInsumosList.value = true;
        loadingGasList.value = true;
        loadingHipoSodioList.value = true;
        loadingBriquetaList.value = true;

        // Si es usuario registrado, filtra solo sus centros poblados asignados
        final Future futureCentros = _authX.hasCredentials
            ? DBProvider.db.listAllCentroPobladoInArray(
                _authX.userCredentials!.misCentrosPoblados)
            : DBProvider.db.listAllCentroPoblado();

        final arrayData = await Future.wait([
          DBProvider.db.listAllTipoImagenByGrupo('CLORACION'),
          futureCentros,
          DBProvider.db.listAllComponentes(),
          DBProvider.db.listAllInsumos(),
          DBProvider.db.listAllMedidaGas(),
          DBProvider.db.listAllMedidaHipocloritos(),
          DBProvider.db.listAllMedidaBriquetas(),
        ]);

        tiposImagen = arrayData[0] as List<TipoImagen>;
        listCentrosPoblados = arrayData[1] as List<CentroPoblado>;
        listComponentes = arrayData[2] as List<Componente>;
        listInsumos = arrayData[3] as List<Insumo>;
        listGas = arrayData[4] as List<MedidaGas>;
        listHipocloritoSodio = arrayData[5] as List<MedidaHipocloritos>;
        listBriquetas = arrayData[6] as List<MedidaBriqueta>;

        loadingCentroList.value = false;
        loadingComponentesList.value = false;
        loadingInsumosList.value = false;
        loadingGasList.value = false;
        loadingHipoSodioList.value = false;
        loadingBriquetaList.value = false;

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
        final encuesta = await DBProvider.db.listCloracionById(id);
        _latitude = encuesta!.latitud;
        _longitude = encuesta.longitud;
        if (isReadOnly) {
          wrapperX.addUniqueMarker(_latitude, _longitude);
          wrapperX.jumpTo(_latitude, _longitude);
          wrapperX.forceSetLatLngLabels(_latitude, _longitude);
        }

        // Obtiene la lista de imagenes
        final storeImages = await DBProvider.db
            .listImagenCloracionByEncuestaId(encuesta.cloracionesId);
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

        final componente = listComponentes
            .firstWhereOrNull((e) => e.componentesId == encuesta.componentesId);
        componenteDropdownKey.currentState!.changeSelectedItem(componente);

        final insumo = listInsumos
            .firstWhereOrNull((e) => e.insumosId == encuesta.insumosId);
        insumoDropdownKey.currentState!.changeSelectedItem(insumo);

        // Delay importante que espera que los extra inputs se muestren
        await Future.delayed(const Duration(milliseconds: 100));

        final gas = listGas
            .firstWhereOrNull((e) => e.medidaGasId == encuesta.medidaGasId);
        gasDropdownKey.currentState?.changeSelectedItem(gas);

        valorInsumoCtlr.text = encuesta.insumoValor?.toString() ?? '';
        solucionMadreCtlr.text = encuesta.solucionMadre?.toString() ?? '';

        final hipoSodio = listHipocloritoSodio.firstWhereOrNull(
            (e) => e.medidaHipocloritosId == encuesta.medidaHipocloritosId);
        hipoSodioDropdownKey.currentState?.changeSelectedItem(hipoSodio);

        final briqueta = listBriquetas.firstWhereOrNull(
            (e) => e.medidaBriquetasId == encuesta.medidaBriquetasId);
        briquetaDropdownKey.currentState?.changeSelectedItem(briqueta);

        selectedCalibracion.value = encuesta.calibracionSistemaCloracion;
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
  }

  Future<void> setComponenteSelected(Componente? selected) async {
    selectedComponente = selected;
  }

  Future<void> setInsumoSelected(Insumo? selected) async {
    selectedInsumo = selected;

    if (selected == null) return;
    _showInputsForms(selected.alias);
  }

  void _showInputsForms(String idInsumo) {
    // Limpia los otros inputs
    setGasSelected(null);
    valorInsumoCtlr.clear();
    solucionMadreCtlr.clear();
    setHipocloritoSodioSelected(null);
    setBriquetaSelected(null);

    switch (idInsumo) {
      case 'GAS':
        extraInputsSelected = InsumoExtraInputs.gas;
        break;
      case 'TABLETA':
        extraInputsSelected = InsumoExtraInputs.tableta;
        break;
      case 'HIPOCLORITO DE CALCIO GRANULADO':
        extraInputsSelected = InsumoExtraInputs.hipoCalcio;
        break;
      case 'HIPOCLORITO DE SODIO':
        extraInputsSelected = InsumoExtraInputs.hipoSodio;
        break;
      case 'BRIQUETA':
        extraInputsSelected = InsumoExtraInputs.briqueta;
        break;
      default:
        extraInputsSelected = InsumoExtraInputs.none;
    }
    update([gbExtraInputs]);
  }

  Future<void> setCalibracionSelected(bool? selected) async {
    selectedCalibracion.value = selected ?? false;
  }

  void setGasSelected(MedidaGas? selected) {
    selectedGas = selected;
  }

  void setHipocloritoSodioSelected(MedidaHipocloritos? selected) {
    selectedHipocloritoSodio = selected;
  }

  void setBriquetaSelected(MedidaBriqueta? selected) {
    selectedBriqueta = selected;
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
      final form = Cloracion(
        cloracionesId: editId ?? await DBProvider.db.getNewIdCloracion(),
        calibracionSistemaCloracion: selectedCalibracion.value,
        fechaInsitu: DateTime.now(),
        recolector: null,
        latitud: _latitude,
        longitud: _longitude,
        insumoValor: Helpers.toDoubleOrNull(valorInsumoCtlr.text),
        centroPobladosId: selectedCentroPoblado!.centroPobladosId,
        solucionMadre: Helpers.toDoubleOrNull(solucionMadreCtlr.text),
        sapId: selectedSap!.sapId,
        componentesId: selectedComponente?.componentesId,
        insumosId: selectedInsumo?.insumosId,
        medidaGasId: selectedGas?.medidaGasId,
        medidaHipocloritosId: selectedHipocloritoSodio?.medidaHipocloritosId,
        medidaBriquetasId: selectedBriqueta?.medidaBriquetasId,
        validado: null,
        historial: null,
        usuarioRegistro: null,
        completo: false,
        enviado: false,
      );

      final isFormCompleted = Cloracion.isCompleteForBackend(form);
      final imagesCompleted = checkPhotosCompleted(tiposImagen, photos);

      final checkedForm = form.copyWith(
        completo: Wrapped.value(isFormCompleted && imagesCompleted),
      );

      await Future.delayed(const Duration(seconds: 1));
      if (editId != null) {
        await DBProvider.db.updateCloracion(checkedForm);
      } else {
        await DBProvider.db.insertCloracion(checkedForm);
      }

      // Elimina todas las imagenes asociadas a la encuesta
      await DBProvider.db.deleteAllImagenCloracionByEncuestaId(
        checkedForm.cloracionesId,
      );
      // Añade las imagenes en la tabla de relacion
      for (var photo in photos) {
        final tempPhoto = RelCloracionTipoImagen(
          imagenId: await DBProvider.db.getNewIdImagenCloracion(),
          nombre: photo.name,
          ruta: photo.file.path,
          tipoImagenId: photo.tipoImagenId,
          fechaInsitu: DateTime.now(),
          cloracionesId: checkedForm.cloracionesId,
          usuarioRegistro: null,
          latitud: photo.latitude,
          longitud: photo.longitude,
        );
        await DBProvider.db.insertImagenCloracion(tempPhoto);
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

class EncuestaCloracionArguments {
  final int? editId;
  final bool readOnly;
  const EncuestaCloracionArguments({this.editId, this.readOnly = false});
}

enum InsumoExtraInputs {
  none,
  gas,
  tableta,
  hipoCalcio,
  hipoSodio,
  briqueta,
}
