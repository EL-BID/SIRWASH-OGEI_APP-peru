// To parse this JSON data, do
//
//     final medidaGas = medidaGasFromJson(jsonString);

import 'dart:convert';

List<MedidaGas> medidaGasFromJson(String str) =>
    List<MedidaGas>.from(json.decode(str).map((x) => MedidaGas.fromBackend(x)));

String medidaGasToJson(List<MedidaGas> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toSQLite())));

class MedidaGas {
  final int medidaGasId;
  final String nombre;
  final String alias;
  final int valor;

  MedidaGas({
    required this.medidaGasId,
    required this.nombre,
    required this.alias,
    required this.valor,
  });

  factory MedidaGas.fromBackend(Map<String, dynamic> json) => MedidaGas(
        medidaGasId: json["medida_gas_id"],
        nombre: json["nombre"],
        alias: json["alias"],
        valor: json["valor"],
      );

  factory MedidaGas.fromSQLite(Map<String, dynamic> json) => MedidaGas(
        medidaGasId: json["MEDIDA_GAS_ID"],
        nombre: json["NOMBRE"],
        alias: json["ALIAS"],
        valor: json["VALOR"],
      );

  Map<String, dynamic> toSQLite() => {
        "MEDIDA_GAS_ID": medidaGasId,
        "NOMBRE": nombre,
        "ALIAS": alias,
        "VALOR": valor,
      };
}
