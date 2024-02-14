import 'package:sirwash/utils/utils.dart';

class RelCloracionTipoImagen {
  final int imagenId;
  final String nombre;
  final String ruta;
  final int tipoImagenId;
  final DateTime fechaInsitu;
  final int cloracionesId;
  final String? usuarioRegistro;
  final double latitud;
  final double longitud;

  RelCloracionTipoImagen({
    required this.imagenId,
    required this.nombre,
    required this.ruta,
    required this.tipoImagenId,
    required this.fechaInsitu,
    required this.cloracionesId,
    this.usuarioRegistro,
    required this.latitud,
    required this.longitud,
  });

  RelCloracionTipoImagen copyWith({
    Wrapped<int>? imagenId,
    Wrapped<String>? nombre,
    Wrapped<String>? ruta,
    Wrapped<int>? tipoImagenId,
    Wrapped<DateTime>? fechaInsitu,
    Wrapped<int>? cloracionesId,
    Wrapped<String?>? usuarioRegistro,
    Wrapped<double>? latitud,
    Wrapped<double>? longitud,
  }) =>
      RelCloracionTipoImagen(
        imagenId: imagenId != null ? imagenId.value : this.imagenId,
        nombre: nombre != null ? nombre.value : this.nombre,
        ruta: ruta != null ? ruta.value : this.ruta,
        tipoImagenId:
            tipoImagenId != null ? tipoImagenId.value : this.tipoImagenId,
        fechaInsitu: fechaInsitu != null ? fechaInsitu.value : this.fechaInsitu,
        cloracionesId:
            cloracionesId != null ? cloracionesId.value : this.cloracionesId,
        usuarioRegistro: usuarioRegistro != null
            ? usuarioRegistro.value
            : this.usuarioRegistro,
        latitud: latitud != null ? latitud.value : this.latitud,
        longitud: longitud != null ? longitud.value : this.longitud,
      );

  factory RelCloracionTipoImagen.fromSQLite(Map<String, dynamic> json) =>
      RelCloracionTipoImagen(
        imagenId: json["IMAGEN_ID"],
        nombre: json["NOMBRE"],
        ruta: json["RUTA"],
        tipoImagenId: json["TIPO_IMAGEN_ID"],
        fechaInsitu: DateTime.parse(json["FECHA_INSITU"]),
        cloracionesId: json["CLORACIONES_ID"],
        usuarioRegistro: json["USUARIO_REGISTRO"],
        latitud: json["LATITUD"].toDouble(),
        longitud: json["LONGITUD"].toDouble(),
      );

  Map<String, dynamic> toSQLite() => {
        "IMAGEN_ID": imagenId,
        "NOMBRE": nombre,
        "RUTA": ruta,
        "TIPO_IMAGEN_ID": tipoImagenId,
        "FECHA_INSITU": fechaInsitu.toIso8601String(),
        "CLORACIONES_ID": cloracionesId,
        "USUARIO_REGISTRO": usuarioRegistro,
        "latitud": latitud,
        "longitud": longitud,
      };
}
