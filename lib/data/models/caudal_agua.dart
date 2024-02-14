// To parse this JSON data, do
//
//     final caudalAgua = caudalAguaFromJson(jsonString);

import 'dart:convert';

List<CaudalAgua> caudalAguaFromJson(String str) => List<CaudalAgua>.from(
    json.decode(str).map((x) => CaudalAgua.fromBackend(x)));

String caudalAguaToJson(List<CaudalAgua> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toSQLite())));

class CaudalAgua {
  final int caudalAguasId;
  final String nombre;
  final String alias;
  final int valor;

  CaudalAgua({
    required this.caudalAguasId,
    required this.nombre,
    required this.alias,
    required this.valor,
  });

  factory CaudalAgua.fromBackend(Map<String, dynamic> json) => CaudalAgua(
        caudalAguasId: json["caudal_aguas_id"],
        nombre: json["nombre"],
        alias: json["alias"],
        valor: int.parse(json["valor"]),
      );

  factory CaudalAgua.fromSQLite(Map<String, dynamic> json) => CaudalAgua(
        caudalAguasId: json["CAUDAL_AGUAS_ID"],
        nombre: json["NOMBRE"],
        alias: json["ALIAS"],
        valor: json["VALOR"],
      );

  Map<String, dynamic> toSQLite() => {
        "CAUDAL_AGUAS_ID": caudalAguasId,
        "NOMBRE": nombre,
        "ALIAS": alias,
        "VALOR": valor,
      };
}
