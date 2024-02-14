import 'package:flutter/foundation.dart';
import 'package:sirwash/data/providers/encuestas_provider.dart';
import 'package:sirwash/utils/utils.dart';

class CloroResidual {
  final int cloroResidualesId;
  final double? reservorioCloro;
  final DateTime? reservorioFecha;
  final double? primeraViviendaCloro;
  final DateTime? primeraViviendaFecha;
  final String? primeraViviendaDni;
  final double? viviendaIntermediaCloro;
  final DateTime? viviendaIntermediaFecha;
  final String? viviendaIntermediaDni;
  final double? ultimaViviendaCloro;
  final DateTime? ultimaViviendaFecha;
  final String? ultimaViviendaDni;
  final DateTime fechaInsitu;
  final String? recolector;
  final double latitud;
  final double longitud;
  final int centroPobladosId;
  final int sapId;
  final String? validado;
  final String? historial;
  final String? usuarioRegistro;
  final bool completo;
  final bool enviado;
  final int? backendId;
  final DateTime? fechaEnviado;

  CloroResidual({
    required this.cloroResidualesId,
    this.reservorioCloro,
    this.reservorioFecha,
    this.primeraViviendaCloro,
    this.primeraViviendaFecha,
    this.primeraViviendaDni,
    this.viviendaIntermediaCloro,
    this.viviendaIntermediaFecha,
    this.viviendaIntermediaDni,
    this.ultimaViviendaCloro,
    this.ultimaViviendaFecha,
    this.ultimaViviendaDni,
    required this.fechaInsitu,
    this.recolector,
    required this.latitud,
    required this.longitud,
    required this.centroPobladosId,
    required this.sapId,
    this.validado,
    this.historial,
    this.usuarioRegistro,
    required this.completo,
    required this.enviado,
    this.backendId,
    this.fechaEnviado,
  });

  CloroResidual copyWith({
    Wrapped<int>? cloroResidualesId,
    Wrapped<double?>? reservorioCloro,
    Wrapped<DateTime?>? reservorioFecha,
    Wrapped<double?>? primeraViviendaCloro,
    Wrapped<DateTime?>? primeraViviendaFecha,
    Wrapped<String?>? primeraViviendaDni,
    Wrapped<double?>? viviendaIntermediaCloro,
    Wrapped<DateTime?>? viviendaIntermediaFecha,
    Wrapped<String?>? viviendaIntermediaDni,
    Wrapped<double?>? ultimaViviendaCloro,
    Wrapped<DateTime?>? ultimaViviendaFecha,
    Wrapped<String?>? ultimaViviendaDni,
    Wrapped<DateTime>? fechaInsitu,
    Wrapped<String?>? recolector,
    Wrapped<double>? latitud,
    Wrapped<double>? longitud,
    Wrapped<int>? centroPobladosId,
    Wrapped<int>? sapId,
    Wrapped<String?>? validado,
    Wrapped<String?>? historial,
    Wrapped<String?>? usuarioRegistro,
    Wrapped<bool>? completo,
    Wrapped<bool>? enviado,
    Wrapped<int?>? backendId,
    Wrapped<DateTime?>? fechaEnviado,
  }) =>
      CloroResidual(
        cloroResidualesId: cloroResidualesId != null
            ? cloroResidualesId.value
            : this.cloroResidualesId,
        reservorioCloro: reservorioCloro != null
            ? reservorioCloro.value
            : this.reservorioCloro,
        reservorioFecha: reservorioFecha != null
            ? reservorioFecha.value
            : this.reservorioFecha,
        primeraViviendaCloro: primeraViviendaCloro != null
            ? primeraViviendaCloro.value
            : this.primeraViviendaCloro,
        primeraViviendaFecha: primeraViviendaFecha != null
            ? primeraViviendaFecha.value
            : this.primeraViviendaFecha,
        primeraViviendaDni: primeraViviendaDni != null
            ? primeraViviendaDni.value
            : this.primeraViviendaDni,
        viviendaIntermediaCloro: viviendaIntermediaCloro != null
            ? viviendaIntermediaCloro.value
            : this.viviendaIntermediaCloro,
        viviendaIntermediaFecha: viviendaIntermediaFecha != null
            ? viviendaIntermediaFecha.value
            : this.viviendaIntermediaFecha,
        viviendaIntermediaDni: viviendaIntermediaDni != null
            ? viviendaIntermediaDni.value
            : this.viviendaIntermediaDni,
        ultimaViviendaCloro: ultimaViviendaCloro != null
            ? ultimaViviendaCloro.value
            : this.ultimaViviendaCloro,
        ultimaViviendaFecha: ultimaViviendaFecha != null
            ? ultimaViviendaFecha.value
            : this.ultimaViviendaFecha,
        ultimaViviendaDni: ultimaViviendaDni != null
            ? ultimaViviendaDni.value
            : this.ultimaViviendaDni,
        fechaInsitu: fechaInsitu != null ? fechaInsitu.value : this.fechaInsitu,
        recolector: recolector != null ? recolector.value : this.recolector,
        latitud: latitud != null ? latitud.value : this.latitud,
        longitud: longitud != null ? longitud.value : this.longitud,
        centroPobladosId: centroPobladosId != null
            ? centroPobladosId.value
            : this.centroPobladosId,
        sapId: sapId != null ? sapId.value : this.sapId,
        validado: validado != null ? validado.value : this.validado,
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

  factory CloroResidual.fromSQLite(Map<String, dynamic> json) => CloroResidual(
        cloroResidualesId: json["CLORO_RESIDUALES_ID"],
        reservorioCloro: json["RESERVORIO_CLORO"]?.toDouble(),
        reservorioFecha: json["RESERVORIO_FECHA"] != null
            ? DateTime.parse(json["RESERVORIO_FECHA"])
            : null,
        primeraViviendaCloro: json["PRIMERA_VIVIENDA_CLORO"]?.toDouble(),
        primeraViviendaFecha: json["PRIMERA_VIVIENDA_FECHA"] != null
            ? DateTime.parse(json["PRIMERA_VIVIENDA_FECHA"])
            : null,
        primeraViviendaDni: json["PRIMERA_VIVIENDA_DNI"],
        viviendaIntermediaCloro: json["VIVIENDA_INTERMEDIA_CLORO"]?.toDouble(),
        viviendaIntermediaFecha: json["VIVIENDA_INTERMEDIA_FECHA"] != null
            ? DateTime.parse(json["VIVIENDA_INTERMEDIA_FECHA"])
            : null,
        viviendaIntermediaDni: json["VIVIENDA_INTERMEDIA_DNI"],
        ultimaViviendaCloro: json["ULTIMA_VIVIENDA_CLORO"]?.toDouble(),
        ultimaViviendaFecha: json["ULTIMA_VIVIENDA_FECHA"] != null
            ? DateTime.parse(json["ULTIMA_VIVIENDA_FECHA"])
            : null,
        ultimaViviendaDni: json["ULTIMA_VIVIENDA_DNI"],
        fechaInsitu: DateTime.parse(json["FECHA_INSITU"]),
        recolector: json["RECOLECTOR"],
        latitud: json["LATITUD"].toDouble(),
        longitud: json["LONGITUD"].toDouble(),
        centroPobladosId: json["CENTRO_POBLADOS_ID"],
        sapId: json["SAP_ID"],
        validado: json["VALIDADO"],
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
        "CLORO_RESIDUALES_ID": cloroResidualesId,
        "RESERVORIO_CLORO": reservorioCloro,
        "RESERVORIO_FECHA": reservorioFecha?.toIso8601String(),
        "PRIMERA_VIVIENDA_CLORO": primeraViviendaCloro,
        "PRIMERA_VIVIENDA_FECHA": primeraViviendaFecha?.toIso8601String(),
        "PRIMERA_VIVIENDA_DNI": primeraViviendaDni,
        "VIVIENDA_INTERMEDIA_CLORO": viviendaIntermediaCloro,
        "VIVIENDA_INTERMEDIA_FECHA": viviendaIntermediaFecha?.toIso8601String(),
        "VIVIENDA_INTERMEDIA_DNI": viviendaIntermediaDni,
        "ULTIMA_VIVIENDA_CLORO": ultimaViviendaCloro,
        "ULTIMA_VIVIENDA_FECHA": ultimaViviendaFecha?.toIso8601String(),
        "ULTIMA_VIVIENDA_DNI": ultimaViviendaDni,
        "FECHA_INSITU": fechaInsitu.toIso8601String(),
        "RECOLECTOR": recolector,
        "LATITUD": latitud,
        "LONGITUD": longitud,
        "CENTRO_POBLADOS_ID": centroPobladosId,
        "SAP_ID": sapId,
        "VALIDADO": validado,
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
        "reservorio_cloro": reservorioCloro,
        "reservorio_fecha":
            EncuestasProvider.insituFormat.format(reservorioFecha!),
        "primera_vivienda_cloro": primeraViviendaCloro,
        "primera_vivienda_fecha":
            EncuestasProvider.insituFormat.format(primeraViviendaFecha!),
        "primera_vivienda_dni": primeraViviendaDni,
        "vivienda_intermedia_cloro": viviendaIntermediaCloro,
        "vivienda_intermedia_fecha":
            EncuestasProvider.insituFormat.format(viviendaIntermediaFecha!),
        "vivienda_intermedia_dni": viviendaIntermediaDni,
        "ultima_vivienda_cloro": ultimaViviendaCloro,
        "ultima_vivienda_fecha":
            EncuestasProvider.insituFormat.format(ultimaViviendaFecha!),
        "ultima_vivienda_dni": ultimaViviendaDni,
        "recolector": recolector,
        "fecha_insitu": EncuestasProvider.insituFormat.format(fechaInsitu),
        "latitud": latitud,
        "longitud": longitud,
        "observacion": null,
        "usuario_registro": usuarioRegistro,
        "origen": null
      };

  /// Función que evalua si las propiedades requeridas han sido completadas
  /// por el usuario, caso contrario, devuelve false.
  ///
  /// Este proceso es necesario para decidir si las encuestas son enviadas
  /// al servidor
  static bool isCompleteForBackend(CloroResidual e) {
    final Map<String, bool> fieldsCompleted = {
      'reservorioCloro': e.reservorioCloro != null,
      'reservorioFecha': e.reservorioFecha != null,
      'primeraViviendaCloro': e.primeraViviendaCloro != null,
      'primeraViviendaFecha': e.primeraViviendaFecha != null,
      'primeraViviendaDni':
          e.primeraViviendaDni != null && e.primeraViviendaDni!.length >= 8,
      'viviendaIntermediaCloro': e.viviendaIntermediaCloro != null,
      'viviendaIntermediaFecha': e.viviendaIntermediaFecha != null,
      'viviendaIntermediaDni': e.viviendaIntermediaDni != null &&
          e.viviendaIntermediaDni!.length >= 8,
      'ultimaViviendaCloro': e.ultimaViviendaCloro != null,
      'ultimaViviendaFecha': e.ultimaViviendaFecha != null,
      'ultimaViviendaDni':
          e.ultimaViviendaDni != null && e.ultimaViviendaDni!.length >= 8,
    };

    debugPrint(fieldsCompleted.toString());

    return !fieldsCompleted.containsValue(false);
  }
}
