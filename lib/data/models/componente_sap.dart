import 'package:flutter/foundation.dart';
import 'package:sirwash/data/providers/encuestas_provider.dart';
import 'package:sirwash/utils/utils.dart';

class ComponenteSap {
  final int componentesapId;
  final double? hipoclorito;
  final DateTime fechaInsitu;
  final String? recolector;
  final String? validado;
  final double latitud;
  final double longitud;
  final int centroPobladosId;
  final int sapId;
  final int? prestadoresId;
  final String? historial;
  final String? usuarioRegistro;
  final bool completo;
  final bool enviado;
  final int? backendId;
  final DateTime? fechaEnviado;

  ComponenteSap({
    required this.componentesapId,
    this.hipoclorito,
    required this.fechaInsitu,
    this.recolector,
    this.validado,
    required this.latitud,
    required this.longitud,
    required this.centroPobladosId,
    required this.sapId,
    this.prestadoresId,
    this.historial,
    this.usuarioRegistro,
    required this.completo,
    required this.enviado,
    this.backendId,
    this.fechaEnviado,
  });

  ComponenteSap copyWith({
    Wrapped<int>? componentesapId,
    Wrapped<double?>? hipoclorito,
    Wrapped<DateTime>? fechaInsitu,
    Wrapped<String?>? recolector,
    Wrapped<String?>? validado,
    Wrapped<double>? latitud,
    Wrapped<double>? longitud,
    Wrapped<int>? centroPobladosId,
    Wrapped<int>? sapId,
    Wrapped<int?>? prestadoresId,
    Wrapped<String?>? historial,
    Wrapped<String?>? usuarioRegistro,
    Wrapped<bool>? completo,
    Wrapped<bool>? enviado,
    Wrapped<int?>? backendId,
    Wrapped<DateTime?>? fechaEnviado,
  }) =>
      ComponenteSap(
        componentesapId: componentesapId != null
            ? componentesapId.value
            : this.componentesapId,
        hipoclorito: hipoclorito != null ? hipoclorito.value : this.hipoclorito,
        fechaInsitu: fechaInsitu != null ? fechaInsitu.value : this.fechaInsitu,
        recolector: recolector != null ? recolector.value : this.recolector,
        validado: validado != null ? validado.value : this.validado,
        latitud: latitud != null ? latitud.value : this.latitud,
        longitud: longitud != null ? longitud.value : this.longitud,
        centroPobladosId: centroPobladosId != null
            ? centroPobladosId.value
            : this.centroPobladosId,
        sapId: sapId != null ? sapId.value : this.sapId,
        prestadoresId:
            prestadoresId != null ? prestadoresId.value : this.prestadoresId,
        historial: historial != null ? historial.value : this.historial,
        usuarioRegistro: usuarioRegistro != null
            ? usuarioRegistro.value
            : this.usuarioRegistro,
        completo: completo != null ? completo.value : this.completo,
        enviado: enviado != null ? enviado.value : this.enviado,
        backendId: backendId != null ? backendId.value : this.backendId,
        fechaEnviado:
            fechaEnviado != null ? fechaEnviado.value : this.fechaEnviado,
      );

  factory ComponenteSap.fromSQLite(Map<String, dynamic> json) => ComponenteSap(
        componentesapId: json["COMPONENTESAP_ID"],
        hipoclorito: json["HIPOCLORITO"]?.toDouble(),
        fechaInsitu: DateTime.parse(json["FECHA_INSITU"]),
        recolector: json["RECOLECTOR"],
        validado: json["VALIDADO"],
        latitud: json["LATITUD"].toDouble(),
        longitud: json["LONGITUD"].toDouble(),
        centroPobladosId: json["CENTRO_POBLADOS_ID"],
        sapId: json["SAP_ID"],
        prestadoresId: json["PRESTADORES_ID"],
        historial: json["HISTORIAL"],
        usuarioRegistro: json["USUARIO_REGISTRO"],
        completo: json['COMPLETO'] == 1,
        enviado: json['ENVIADO'] == 1,
        backendId: json["BACKEND_ID"],
        fechaEnviado: json["FECHA_ENVIADO"] != null
            ? DateTime.parse(json["FECHA_ENVIADO"])
            : null,
      );

  Map<String, dynamic> toSQLite() => {
        "COMPONENTESAP_ID": componentesapId,
        "HIPOCLORITO": hipoclorito,
        "FECHA_INSITU": fechaInsitu.toIso8601String(),
        "RECOLECTOR": recolector,
        "VALIDADO": validado,
        "LATITUD": latitud,
        "LONGITUD": longitud,
        "CENTRO_POBLADOS_ID": centroPobladosId,
        "SAP_ID": sapId,
        "PRESTADORES_ID": prestadoresId,
        "HISTORIAL": historial,
        "USUARIO_REGISTRO": usuarioRegistro,
        "COMPLETO": completo ? 1 : 0,
        "ENVIADO": enviado ? 1 : 0,
        "BACKEND_ID": backendId,
        "FECHA_ENVIADO": fechaEnviado?.toIso8601String(),
      };

  Map<String, dynamic> toBackend() => {
        "hipoclorito": hipoclorito,
        "fecha_insitu": EncuestasProvider.insituFormat.format(fechaInsitu),
        "recolector": recolector,
        "latitud": latitud,
        "longitud": longitud,
        "observacion": null,
        "centro_poblados_id": centroPobladosId,
        "sap_id": sapId,
        "prestadores_id": prestadoresId,
        "usuario_registro": usuarioRegistro,
        "origen": null
      };

  /// Función que evalua si las propiedades requeridas han sido completadas
  /// por el usuario, caso contrario, devuelve false.
  ///
  /// Este proceso es necesario para decidir si las encuestas son enviadas
  /// al servidor
  static bool isCompleteForBackend(ComponenteSap e) {
    final Map<String, bool> fieldsCompleted = {
      'hipoclorito': e.hipoclorito != null
    };

    debugPrint(fieldsCompleted.toString());

    return !fieldsCompleted.containsValue(false);
  }
}
