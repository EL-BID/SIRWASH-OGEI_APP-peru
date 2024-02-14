import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:get/instance_manager.dart';
import 'package:http_parser/http_parser.dart';
import 'package:intl/intl.dart';
import 'package:sirwash/data/models/models.dart';
import 'package:sirwash/utils/utils.dart';

class EncuestasProvider {
  final DioClient _dioClient = Get.find<DioClient>();

  /// Establece un modelo de fecha en común según como lo solicita el backend,
  /// además evita que el backend devuelva errores.
  static final insituFormat = DateFormat('yyyy-MM-dd hh:mm:ss');

  // BEGIN :: CLORORESIDUAL
  Future<int> postCloroResidual(CloroResidual entity) async {
    final id = await _dioClient.post(
      '/medicionclororesidual',
      data: entity.toBackend(),
    );
    return id;
  }

  Future<void> postImagenesCloroResidual(
    CloroResidual entity,
    List<RelCloroResidualTipoImagen> images,
  ) async {
    /// Dado que el backend no acepta json cuando se envia multipart-form
    /// Se está creando un mapa para luego pasarlo a stringify
    final stringifyData = json.encode(images
        .map((e) => {
              'IdTipoImagen': e.tipoImagenId,
              'NombreImagen': e.nombre,
              'latitud': e.latitud,
              'longitud': e.longitud,
            })
        .toList());
    final data = {
      'files': [
        ...images.map((e) => MultipartFile.fromFileSync(
              e.ruta,
              filename: e.nombre,
              contentType: MediaType('image', 'jpeg'),
            ))
      ],
      'UsuarioRegistro': entity.usuarioRegistro,
      'FechaInsitu': entity.fechaInsitu,
      'IdEncuesta': entity.backendId,
      'TipoImagen': stringifyData
    };

    await _dioClient.post('/CloroResidual/UploadFiles',
        data: FormData.fromMap(data));
  }
  // END :: CLORORESIDUAL

  // BEGIN :: COMPONENTESAP
  Future<int> postComponenteSap(ComponenteSap entity) async {
    final id = await _dioClient.post(
      '/limpiezadesinfeccion',
      data: entity.toBackend(),
    );
    return id;
  }

  Future<void> postImagenesComponenteSap(
    ComponenteSap entity,
    List<RelComponenteSapTipoImagen> images,
  ) async {
    /// Dado que el backend no acepta json cuando se envia multipart-form
    /// Se está creando un mapa para luego pasarlo a stringify
    final stringifyData = json.encode(images
        .map((e) => {
              'IdTipoImagen': e.tipoImagenId,
              'NombreImagen': e.nombre,
              'latitud': e.latitud,
              'longitud': e.longitud,
            })
        .toList());
    final data = {
      'files': [
        ...images.map((e) => MultipartFile.fromFileSync(
              e.ruta,
              filename: e.nombre,
              contentType: MediaType('image', 'jpeg'),
            ))
      ],
      'UsuarioRegistro': entity.usuarioRegistro,
      'FechaInsitu': entity.fechaInsitu,
      'IdEncuesta': entity.backendId,
      'TipoImagen': stringifyData
    };

    await _dioClient.post('/Componente/UploadFiles',
        data: FormData.fromMap(data));
  }
  // END :: COMPONENTESAP

  // BEGIN :: CONTINUIDADSERVICIO
  Future<int> postContinuidadServicio(ContinuidadServicio entity) async {
    final id = await _dioClient.post(
      '/continudadservicio',
      data: entity.toBackend(),
    );
    return id;
  }

  Future<void> postImagenesContinuidadServicio(
    ContinuidadServicio entity,
    List<RelContinuidadServicioTipoImagen> images,
  ) async {
    /// Dado que el backend no acepta json cuando se envia multipart-form
    /// Se está creando un mapa para luego pasarlo a stringify
    final stringifyData = json.encode(images
        .map((e) => {
              'IdTipoImagen': e.tipoImagenId,
              'NombreImagen': e.nombre,
              'latitud': e.latitud,
              'longitud': e.longitud,
            })
        .toList());
    final data = {
      'files': [
        ...images.map((e) => MultipartFile.fromFileSync(
              e.ruta,
              filename: e.nombre,
              contentType: MediaType('image', 'jpeg'),
            ))
      ],
      'UsuarioRegistro': entity.usuarioRegistro,
      'FechaInsitu': entity.fechaInsitu,
      'IdEncuesta': entity.backendId,
      'TipoImagen': stringifyData
    };

    await _dioClient.post('/ContinuidadServicio/UploadFiles',
        data: FormData.fromMap(data));
  }
  // END :: CONTINUIDADSERVICIO

  // BEGIN :: CLORACION
  Future<int> postCloracion(Cloracion entity) async {
    final id = await _dioClient.post(
      '/cloracion',
      data: entity.toBackend(),
    );
    return id;
  }

  Future<void> postImagenesCloracion(
    Cloracion entity,
    List<RelCloracionTipoImagen> images,
  ) async {
    /// Dado que el backend no acepta json cuando se envia multipart-form
    /// Se está creando un mapa para luego pasarlo a stringify
    final stringifyData = json.encode(images
        .map((e) => {
              'IdTipoImagen': e.tipoImagenId,
              'NombreImagen': e.nombre,
              'latitud': e.latitud,
              'longitud': e.longitud,
            })
        .toList());
    final data = {
      'files': [
        ...images.map((e) => MultipartFile.fromFileSync(
              e.ruta,
              filename: e.nombre,
              contentType: MediaType('image', 'jpeg'),
            ))
      ],
      'UsuarioRegistro': entity.usuarioRegistro,
      'FechaInsitu': entity.fechaInsitu,
      'IdEncuesta': entity.backendId,
      'TipoImagen': stringifyData
    };

    await _dioClient.post('/Cloracion/UploadFiles',
        data: FormData.fromMap(data));
  }
  // END :: CLORACION
}
