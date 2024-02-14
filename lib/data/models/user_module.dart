// To parse this JSON data, do
//
//     final userModule = userModuleFromJson(jsonString);

import 'dart:convert';

List<UserModule> userModuleFromJson(String str) =>
    List<UserModule>.from(json.decode(str).map((x) => UserModule.fromJson(x)));

String userModuleToJson(List<UserModule> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class UserModule {
  final int moduloId;
  final String nombre;
  final String descripcion;
  final String keycode;
  final String historial;

  UserModule({
    required this.moduloId,
    required this.nombre,
    required this.descripcion,
    required this.keycode,
    required this.historial,
  });

  factory UserModule.fromJson(Map<String, dynamic> json) => UserModule(
        moduloId: json["modulo_id"],
        nombre: json["nombre"],
        descripcion: json["descripcion"],
        keycode: json["keycode"],
        historial: json["historial"],
      );

  Map<String, dynamic> toJson() => {
        "modulo_id": moduloId,
        "nombre": nombre,
        "descripcion": descripcion,
        "keycode": keycode,
        "historial": historial,
      };
}
