// To parse this JSON data, do
//
//     final medidaHipocloritos = medidaHipocloritosFromJson(jsonString);

import 'dart:convert';

List<MedidaHipocloritos> medidaHipocloritosFromJson(String str) =>
    List<MedidaHipocloritos>.from(
        json.decode(str).map((x) => MedidaHipocloritos.fromBackend(x)));

String medidaHipocloritosToJson(List<MedidaHipocloritos> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toSQLite())));

class MedidaHipocloritos {
  final int medidaHipocloritosId;
  final String nombre;
  final String alias;
  final double valor;

  MedidaHipocloritos({
    required this.medidaHipocloritosId,
    required this.nombre,
    required this.alias,
    required this.valor,
  });

  factory MedidaHipocloritos.fromBackend(Map<String, dynamic> json) =>
      MedidaHipocloritos(
        medidaHipocloritosId: json["medida_hipocloritos_id"],
        nombre: json["nombre"],
        alias: json["alias"],
        valor: json["valor"]?.toDouble(),
      );

  factory MedidaHipocloritos.fromSQLite(Map<String, dynamic> json) =>
      MedidaHipocloritos(
        medidaHipocloritosId: json["MEDIDA_HIPOCLORITOS_ID"],
        nombre: json["NOMBRE"],
        alias: json["ALIAS"],
        valor: json["VALOR"]?.toDouble(),
      );

  Map<String, dynamic> toSQLite() => {
        "MEDIDA_HIPOCLORITOS_ID": medidaHipocloritosId,
        "NOMBRE": nombre,
        "ALIAS": alias,
        "VALOR": valor,
      };
}
