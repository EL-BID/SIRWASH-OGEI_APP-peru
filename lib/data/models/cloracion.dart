import 'package:flutter/foundation.dart';
import 'package:sirwash/data/providers/encuestas_provider.dart';
import 'package:sirwash/utils/utils.dart';

class Cloracion {
  final int cloracionesId;
  final bool calibracionSistemaCloracion;
  final DateTime fechaInsitu;
  final String? recolector;
  final double latitud;
  final double longitud;
  final double? insumoValor;
  final int centroPobladosId;
  final double? solucionMadre;
  final int sapId;
  final int? componentesId;
  final int? insumosId;
  final int? medidaGasId;
  final int? medidaHipocloritosId;
  final int? medidaBriquetasId;
  final String? validado;
  final String? historial;
  final String? usuarioRegistro;
  final bool completo;
  final bool enviado;
  final int? backendId;
  final DateTime? fechaEnviado;

  Cloracion({
    required this.cloracionesId,
    required this.calibracionSistemaCloracion,
    required this.fechaInsitu,
    this.recolector,
    required this.latitud,
    required this.longitud,
    this.insumoValor,
    required this.centroPobladosId,
    this.solucionMadre,
    required this.sapId,
    this.componentesId,
    this.insumosId,
    this.medidaGasId,
    this.medidaHipocloritosId,
    this.medidaBriquetasId,
    this.validado,
    this.historial,
    this.usuarioRegistro,
    required this.completo,
    required this.enviado,
    this.backendId,
    this.fechaEnviado,
  });

  Cloracion copyWith({
    Wrapped<int>? cloracionesId,
    Wrapped<bool>? calibracionSistemaCloracion,
    Wrapped<DateTime>? fechaInsitu,
    Wrapped<String?>? recolector,
    Wrapped<double>? latitud,
    Wrapped<double>? longitud,
    Wrapped<double?>? insumoValor,
    Wrapped<int>? centroPobladosId,
    Wrapped<double?>? solucionMadre,
    Wrapped<int>? sapId,
    Wrapped<int?>? componentesId,
    Wrapped<int?>? insumosId,
    Wrapped<int?>? medidaGasId,
    Wrapped<int?>? medidaHipocloritosId,
    Wrapped<int?>? medidaBriquetasId,
    Wrapped<String?>? validado,
    Wrapped<String?>? historial,
    Wrapped<String?>? usuarioRegistro,
    Wrapped<bool>? completo,
    Wrapped<bool>? enviado,
    Wrapped<int?>? backendId,
    Wrapped<DateTime?>? fechaEnviado,
  }) =>
      Cloracion(
        cloracionesId:
            cloracionesId != null ? cloracionesId.value : this.cloracionesId,
        calibracionSistemaCloracion: calibracionSistemaCloracion != null
            ? calibracionSistemaCloracion.value
            : this.calibracionSistemaCloracion,
        fechaInsitu: fechaInsitu != null ? fechaInsitu.value : this.fechaInsitu,
        recolector: recolector != null ? recolector.value : this.recolector,
        latitud: latitud != null ? latitud.value : this.latitud,
        longitud: longitud != null ? longitud.value : this.longitud,
        insumoValor: insumoValor != null ? insumoValor.value : this.insumoValor,
        centroPobladosId: centroPobladosId != null
            ? centroPobladosId.value
            : this.centroPobladosId,
        solucionMadre:
            solucionMadre != null ? solucionMadre.value : this.solucionMadre,
        sapId: sapId != null ? sapId.value : this.sapId,
        componentesId:
            componentesId != null ? componentesId.value : this.componentesId,
        insumosId: insumosId != null ? insumosId.value : this.insumosId,
        medidaGasId: medidaGasId != null ? medidaGasId.value : this.medidaGasId,
        medidaHipocloritosId: medidaHipocloritosId != null
            ? medidaHipocloritosId.value
            : this.medidaHipocloritosId,
        medidaBriquetasId: medidaBriquetasId != null
            ? medidaBriquetasId.value
            : this.medidaBriquetasId,
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

  factory Cloracion.fromSQLite(Map<String, dynamic> json) => Cloracion(
        cloracionesId: json["CLORACIONES_ID"],
        calibracionSistemaCloracion:
            json["CALIBRACION_SISTEMA_CLORACION"] == '1',
        fechaInsitu: DateTime.parse(json["FECHA_INSITU"]),
        recolector: json["RECOLECTOR"],
        latitud: json["LATITUD"].toDouble(),
        longitud: json["LONGITUD"].toDouble(),
        insumoValor: json["INSUMO_VALOR"]?.toDouble(),
        centroPobladosId: json["CENTRO_POBLADOS_ID"],
        solucionMadre: json["SOLUCION_MADRE"]?.toDouble(),
        sapId: json["SAP_ID"],
        componentesId: json["COMPONENTES_ID"],
        insumosId: json["INSUMOS_ID"],
        medidaGasId: json["MEDIDA_GAS_ID"],
        medidaHipocloritosId: json["MEDIDA_HIPOCLORITOS_ID"],
        medidaBriquetasId: json["MEDIDA_BRIQUETAS_ID"],
        validado: json["VALIDADO"],
        historial: json["HISTORIAL"],
        usuarioRegistro: json["USUARIO_REGISTRO"],
        completo: json["COMPLETO"] == 1,
        enviado: json["ENVIADO"] == 1,
        backendId: json["BACKEND_ID"],
        fechaEnviado: json["FECHA_ENVIADO"] != null
            ? DateTime.parse(json["FECHA_ENVIADO"])
            : null,
      );

  Map<String, dynamic> toSQLite() => {
        "CLORACIONES_ID": cloracionesId,
        "CALIBRACION_SISTEMA_CLORACION":
            calibracionSistemaCloracion ? '1' : '0',
        "FECHA_INSITU": fechaInsitu.toIso8601String(),
        "RECOLECTOR": recolector,
        "LATITUD": latitud,
        "LONGITUD": longitud,
        "INSUMO_VALOR": insumoValor,
        "CENTRO_POBLADOS_ID": centroPobladosId,
        "SOLUCION_MADRE": solucionMadre,
        "SAP_ID": sapId,
        "COMPONENTES_ID": componentesId,
        "INSUMOS_ID": insumosId,
        "MEDIDA_GAS_ID": medidaGasId,
        "MEDIDA_HIPOCLORITOS_ID": medidaHipocloritosId,
        "MEDIDA_BRIQUETAS_ID": medidaBriquetasId,
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
        "componentes_id": componentesId,
        "insumos_id": insumosId,
        "insumo_valor": insumoValor,
        "medida_gas_id": medidaGasId,
        "medida_hipocloritos_id": medidaHipocloritosId,
        "medida_briquetas_id": medidaBriquetasId,
        "solucion_madre": solucionMadre,
        "calibracion_sistema_cloracion":
            calibracionSistemaCloracion ? "1" : "0",
        "observacion": null,
        "recolector": recolector,
        "fecha_insitu": EncuestasProvider.insituFormat.format(fechaInsitu),
        "latitud": latitud,
        "longitud": longitud,
        "usuario_registro": usuarioRegistro,
        "origen": null
      };

  /// Función que evalua si las propiedades requeridas han sido completadas
  /// por el usuario, caso contrario, devuelve false.
  ///
  /// Este proceso es necesario para decidir si las encuestas son enviadas
  /// al servidor
  static bool isCompleteForBackend(Cloracion e) {
    // Si almenos un input es falso, extraInputs será true
    final allExtraInputsAreNull = e.medidaGasId == null &&
        e.insumoValor == null &&
        e.solucionMadre == null &&
        e.medidaHipocloritosId == null &&
        e.medidaBriquetasId == null;

    final Map<String, bool> fieldsCompleted = {
      'componentesId': e.componentesId != null,
      'insumosId': e.insumosId != null,
      'extraInputs': !allExtraInputsAreNull,
    };

    debugPrint(fieldsCompleted.toString());

    return !fieldsCompleted.containsValue(false);
  }
}
