// To parse this JSON data, do
//
//     final insumo = insumoFromJson(jsonString);

import 'dart:convert';

List<Insumo> insumoFromJson(String str) =>
    List<Insumo>.from(json.decode(str).map((x) => Insumo.fromBackend(x)));

String insumoToJson(List<Insumo> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toSQLite())));

class Insumo {
  final int insumosId;
  final String nombre;
  final String alias;

  Insumo({
    required this.insumosId,
    required this.nombre,
    required this.alias,
  });

  factory Insumo.fromBackend(Map<String, dynamic> json) => Insumo(
        insumosId: json["insumos_id"],
        nombre: json["nombre"],
        alias: json["alias"],
      );

  factory Insumo.fromSQLite(Map<String, dynamic> json) => Insumo(
        insumosId: json["INSUMOS_ID"],
        nombre: json["NOMBRE"],
        alias: json["ALIAS"],
      );

  Map<String, dynamic> toSQLite() => {
        "INSUMOS_ID": insumosId,
        "NOMBRE": nombre,
        "ALIAS": alias,
      };
}
