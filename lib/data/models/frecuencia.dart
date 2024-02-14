// To parse this JSON data, do
//
//     final frecuencia = frecuenciaFromJson(jsonString);

import 'dart:convert';

List<Frecuencia> frecuenciaFromJson(String str) => List<Frecuencia>.from(
    json.decode(str).map((x) => Frecuencia.fromBackend(x)));

String frecuenciaToJson(List<Frecuencia> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toSQLite())));

class Frecuencia {
  final int frecuenciasId;
  final String nombre;
  final String alias;
  final int valor;

  Frecuencia({
    required this.frecuenciasId,
    required this.nombre,
    required this.alias,
    required this.valor,
  });

  factory Frecuencia.fromBackend(Map<String, dynamic> json) => Frecuencia(
        frecuenciasId: json["frecuencias_id"],
        nombre: json["nombre"],
        alias: json["alias"],
        valor: json["valor"],
      );

  factory Frecuencia.fromSQLite(Map<String, dynamic> json) => Frecuencia(
        frecuenciasId: json["FRECUENCIAS_ID"],
        nombre: json["NOMBRE"],
        alias: json["ALIAS"],
        valor: json["VALOR"],
      );

  Map<String, dynamic> toSQLite() => {
        "FRECUENCIAS_ID": frecuenciasId,
        "NOMBRE": nombre,
        "ALIAS": alias,
        "VALOR": valor,
      };
}
