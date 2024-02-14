// To parse this JSON data, do
//
//     final tipoImagen = tipoImagenFromJson(jsonString);

import 'dart:convert';

List<TipoImagen> tipoImagenFromJson(String str) => List<TipoImagen>.from(
    json.decode(str).map((x) => TipoImagen.fromBackend(x)));

String tipoImagenToJson(List<TipoImagen> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toSQLite())));

class TipoImagen {
  final int tipoImagenesId;
  final String nombre;
  final String grupo;
  final bool requerido;
  final int orden;

  TipoImagen({
    required this.tipoImagenesId,
    required this.nombre,
    required this.grupo,
    required this.requerido,
    required this.orden,
  });

  factory TipoImagen.fromBackend(Map<String, dynamic> json) => TipoImagen(
        tipoImagenesId: json["tipo_imagenes_id"],
        nombre: json["nombre"],
        grupo: json["grupo"],
        requerido: json["requerido"] == '1',
        orden: int.parse(json["orden"]),
      );

  factory TipoImagen.fromSQLite(Map<String, dynamic> json) => TipoImagen(
        tipoImagenesId: json["TIPO_IMAGENES_ID"],
        nombre: json["NOMBRE"],
        grupo: json["GRUPO"],
        requerido: json["REQUERIDO"] == '1',
        orden: int.parse(json["ORDEN"]),
      );

  Map<String, dynamic> toSQLite() => {
        "TIPO_IMAGENES_ID": tipoImagenesId,
        "NOMBRE": nombre,
        "GRUPO": grupo,
        "REQUERIDO": requerido ? '1' : '0',
        "ORDEN": orden.toString(),
      };
}
