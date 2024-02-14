// To parse this JSON data, do
//
//     final medidaBriqueta = medidaBriquetaFromJson(jsonString);

import 'dart:convert';

List<MedidaBriqueta> medidaBriquetaFromJson(String str) =>
    List<MedidaBriqueta>.from(
        json.decode(str).map((x) => MedidaBriqueta.fromBackend(x)));

String medidaBriquetaToJson(List<MedidaBriqueta> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toSQLite())));

class MedidaBriqueta {
  final int medidaBriquetasId;
  final String nombre;
  final String alias;
  final double valor;

  MedidaBriqueta({
    required this.medidaBriquetasId,
    required this.nombre,
    required this.alias,
    required this.valor,
  });

  factory MedidaBriqueta.fromBackend(Map<String, dynamic> json) =>
      MedidaBriqueta(
        medidaBriquetasId: json["medida_briquetas_id"],
        nombre: json["nombre"],
        alias: json["alias"],
        valor: json["valor"]?.toDouble(),
      );

  factory MedidaBriqueta.fromSQLite(Map<String, dynamic> json) =>
      MedidaBriqueta(
        medidaBriquetasId: json["MEDIDA_BRIQUETAS_ID"],
        nombre: json["NOMBRE"],
        alias: json["ALIAS"],
        valor: json["VALOR"]?.toDouble(),
      );

  Map<String, dynamic> toSQLite() => {
        "MEDIDA_BRIQUETAS_ID": medidaBriquetasId,
        "NOMBRE": nombre,
        "ALIAS": alias,
        "VALOR": valor,
      };
}
