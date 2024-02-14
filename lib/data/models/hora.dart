// To parse this JSON data, do
//
//     final hora = horaFromJson(jsonString);

import 'dart:convert';

List<Hora> horaFromJson(String str) =>
    List<Hora>.from(json.decode(str).map((x) => Hora.fromBackend(x)));

String horaToJson(List<Hora> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toSQLite())));

class Hora {
  final int horasId;
  final String nombre;
  final String alias;
  final int valor;

  Hora({
    required this.horasId,
    required this.nombre,
    required this.alias,
    required this.valor,
  });

  factory Hora.fromBackend(Map<String, dynamic> json) => Hora(
        horasId: json["horas_id"],
        nombre: json["nombre"],
        alias: json["alias"],
        valor: json["valor"],
      );

  factory Hora.fromSQLite(Map<String, dynamic> json) => Hora(
        horasId: json["HORAS_ID"],
        nombre: json["NOMBRE"],
        alias: json["ALIAS"],
        valor: json["VALOR"],
      );

  Map<String, dynamic> toSQLite() => {
        "HORAS_ID": horasId,
        "NOMBRE": nombre,
        "ALIAS": alias,
        "VALOR": valor,
      };
}
