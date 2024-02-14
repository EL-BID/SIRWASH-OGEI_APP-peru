// To parse this JSON data, do
//
//     final sap = sapFromJson(jsonString);

import 'dart:convert';

List<Sap> sapFromJson(String str) =>
    List<Sap>.from(json.decode(str).map((x) => Sap.fromJson(x)));

String sapToJson(List<Sap> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Sap {
  final int sapId;
  final String codigo;
  final String nombre;
  final String codigoCentroPoblados;
  final String alias;

  Sap({
    required this.sapId,
    required this.codigo,
    required this.nombre,
    required this.codigoCentroPoblados,
    required this.alias,
  });

  factory Sap.fromJson(Map<String, dynamic> json) => Sap(
        sapId: json["sap_id"],
        codigo: json["codigo"],
        nombre: json["nombre"],
        codigoCentroPoblados: json["codigo_centro_poblados"],
        alias: json["alias"],
      );

  factory Sap.fromSQLite(Map<String, dynamic> json) => Sap(
        sapId: json["SAP_ID"],
        codigo: json["CODIGO"],
        nombre: json["NOMBRE"],
        codigoCentroPoblados: json["CODIGO_CENTRO_POBLADOS"],
        alias: json["ALIAS"],
      );

  Map<String, dynamic> toJson() => {
        "sap_id": sapId,
        "codigo": codigo,
        "nombre": nombre,
        "codigo_centro_poblados": codigoCentroPoblados,
        "alias": alias,
      };
}
