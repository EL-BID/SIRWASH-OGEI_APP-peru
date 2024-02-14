import 'package:flutter/foundation.dart';
import 'package:sirwash/data/providers/encuestas_provider.dart';
import 'package:sirwash/utils/utils.dart';

class ContinuidadServicio {
  final int continuidadServiciosId;
  final double? caudalTiempo1;
  final double? caudalTiempo2;
  final double? caudalTiempo3;
  final DateTime fechaInsitu;
  final String? recolector;
  final String? validado;
  final double latitud;
  final double longitud;
  final int centroPobladosId;
  final int sapId;
  final int? frecuenciasId;
  final int? horasId;
  final int? caudalAguasId;
  final String? historial;
  final String? usuarioRegistro;
  final bool completo;
  final bool enviado;
  final int? backendId;
  final DateTime? fechaEnviado;

  ContinuidadServicio({
    required this.continuidadServiciosId,
    this.caudalTiempo1,
    this.caudalTiempo2,
    this.caudalTiempo3,
    required this.fechaInsitu,
    this.recolector,
    this.validado,
    required this.latitud,
    required this.longitud,
    required this.centroPobladosId,
    required this.sapId,
    this.frecuenciasId,
    this.horasId,
    this.caudalAguasId,
    this.historial,
    this.usuarioRegistro,
    required this.completo,
    required this.enviado,
    this.backendId,
    this.fechaEnviado,
  });

  ContinuidadServicio copyWith({
    Wrapped<int>? continuidadServiciosId,
    Wrapped<double?>? caudalTiempo1,
    Wrapped<double?>? caudalTiempo2,
    Wrapped<double?>? caudalTiempo3,
    Wrapped<DateTime>? fechaInsitu,
    Wrapped<String?>? recolector,
    Wrapped<String?>? validado,
    Wrapped<double>? latitud,
    Wrapped<double>? longitud,
    Wrapped<int>? centroPobladosId,
    Wrapped<int>? sapId,
    Wrapped<int?>? frecuenciasId,
    Wrapped<int?>? horasId,
    Wrapped<int?>? caudalAguasId,
    Wrapped<String?>? historial,
    Wrapped<String?>? usuarioRegistro,
    Wrapped<bool>? completo,
    Wrapped<bool>? enviado,
    Wrapped<int?>? backendId,
    Wrapped<DateTime?>? fechaEnviado,
  }) =>
      ContinuidadServicio(
        continuidadServiciosId: continuidadServiciosId != null
            ? continuidadServiciosId.value
            : this.continuidadServiciosId,
        caudalTiempo1:
            caudalTiempo1 != null ? caudalTiempo1.value : this.caudalTiempo1,
        caudalTiempo2:
            caudalTiempo2 != null ? caudalTiempo2.value : this.caudalTiempo2,
        caudalTiempo3:
            caudalTiempo3 != null ? caudalTiempo3.value : this.caudalTiempo3,
        fechaInsitu: fechaInsitu != null ? fechaInsitu.value : this.fechaInsitu,
        recolector: recolector != null ? recolector.value : this.recolector,
        validado: validado != null ? validado.value : this.validado,
        latitud: latitud != null ? latitud.value : this.latitud,
        longitud: longitud != null ? longitud.value : this.longitud,
        centroPobladosId: centroPobladosId != null
            ? centroPobladosId.value
            : this.centroPobladosId,
        sapId: sapId != null ? sapId.value : this.sapId,
        frecuenciasId:
            frecuenciasId != null ? frecuenciasId.value : this.frecuenciasId,
        horasId: horasId != null ? horasId.value : this.horasId,
        caudalAguasId:
            caudalAguasId != null ? caudalAguasId.value : this.caudalAguasId,
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

  factory ContinuidadServicio.fromSQLite(Map<String, dynamic> json) =>
      ContinuidadServicio(
        continuidadServiciosId: json["CONTINUIDAD_SERVICIOS_ID"],
        caudalTiempo1: json["CAUDAL_TIEMPO1"]?.toDouble(),
        caudalTiempo2: json["CAUDAL_TIEMPO2"]?.toDouble(),
        caudalTiempo3: json["CAUDAL_TIEMPO3"]?.toDouble(),
        fechaInsitu: DateTime.parse(json["FECHA_INSITU"]),
        recolector: json["RECOLECTOR"],
        validado: json["VALIDADO"],
        latitud: json["LATITUD"].toDouble(),
        longitud: json["LONGITUD"].toDouble(),
        centroPobladosId: json["CENTRO_POBLADOS_ID"],
        sapId: json["SAP_ID"],
        frecuenciasId: json["FRECUENCIAS_ID"],
        horasId: json["HORAS_ID"],
        caudalAguasId: json["CAUDAL_AGUAS_ID"],
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
        "CONTINUIDAD_SERVICIOS_ID": continuidadServiciosId,
        "CAUDAL_TIEMPO1": caudalTiempo1,
        "CAUDAL_TIEMPO2": caudalTiempo2,
        "CAUDAL_TIEMPO3": caudalTiempo3,
        "FECHA_INSITU": fechaInsitu.toIso8601String(),
        "RECOLECTOR": recolector,
        "VALIDADO": validado,
        "LATITUD": latitud,
        "LONGITUD": longitud,
        "CENTRO_POBLADOS_ID": centroPobladosId,
        "SAP_ID": sapId,
        "FRECUENCIAS_ID": frecuenciasId,
        "HORAS_ID": horasId,
        "CAUDAL_AGUAS_ID": caudalAguasId,
        "HISTORIAL": historial,
        "USUARIO_REGISTRO": usuarioRegistro,
        "COMPLETO": completo ? 1 : 0,
        "ENVIADO": enviado ? 1 : 0,
        "BACKEND_ID": backendId,
        "FECHA_ENVIADO": fechaEnviado?.toIso8601String(),
      };

  Map<String, dynamic> toBackend() => {
        "centro_poblados_id": centroPobladosId,
        "sap_id": sapId,
        "frecuencias_id": frecuenciasId,
        "horas_id": horasId,
        "caudal_aguas_id": caudalAguasId,
        "caudal_tiempo1": caudalTiempo1,
        "caudal_tiempo2": caudalTiempo2,
        "caudal_tiempo3": caudalTiempo3,
        "observacion": null,
        "recolector": recolector,
        "latitud": latitud,
        "longitud": longitud,
        "usuario_registro": usuarioRegistro,
        "fecha_insitu": EncuestasProvider.insituFormat.format(fechaInsitu),
        "origen": null
      };

  /// Función que evalua si las propiedades requeridas han sido completadas
  /// por el usuario, caso contrario, devuelve false.
  ///
  /// Este proceso es necesario para decidir si las encuestas son enviadas
  /// al servidor
  static bool isCompleteForBackend(ContinuidadServicio e) {
    final Map<String, bool> fieldsCompleted = {
      'frecuenciasId': e.frecuenciasId != null,
      'horasId': e.horasId != null,
      'caudalAguasId': e.caudalAguasId != null,
      'caudalTiempo1': e.caudalTiempo1 != null,
      'caudalTiempo2': e.caudalTiempo2 != null,
      'caudalTiempo3': e.caudalTiempo3 != null,
    };

    debugPrint(fieldsCompleted.toString());

    return !fieldsCompleted.containsValue(false);
  }
}
