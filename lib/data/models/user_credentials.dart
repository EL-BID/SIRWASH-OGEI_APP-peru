// To parse this JSON data, do
//
//     final userCredentials = userCredentialsFromJson(jsonString);

import 'dart:convert';

import 'package:sirwash/data/models/models.dart';

UserCredentials userCredentialsFromJson(String str) =>
    UserCredentials.fromJson(json.decode(str));

String userCredentialsToJson(UserCredentials data) =>
    json.encode(data.toJson());

class UserCredentials {
  UserCredentials({
    this.hasCredentials = false,
    this.iduser,
    this.usuario,
    this.usuarioAlias,
    this.nombre,
    this.apellido,
    this.dni,
    this.perfil,
    this.estado,
    this.token,
    this.modules = const [],
    this.misCentrosPoblados = const [],
  });

  final bool hasCredentials;
  final int? iduser;
  final String? usuario;
  final String? usuarioAlias;
  final String? nombre;
  final String? apellido;
  final String? dni;
  final String? perfil;
  final String? estado;
  final String? token;
  final List<UserModule> modules;
  final List<MisCentroPoblados> misCentrosPoblados;

  factory UserCredentials.fromJson(Map<String, dynamic> json) =>
      UserCredentials(
        hasCredentials: json["hasCredentials"],
        iduser: json["iduser"],
        usuario: json["usuario"],
        usuarioAlias: json["usuarioAlias"],
        nombre: json["nombre"],
        apellido: json["apellido"],
        dni: json["dni"],
        perfil: json["perfil"],
        estado: json["estado"],
        token: json["token"],
        modules: List<UserModule>.from(
            json["modules"].map((x) => UserModule.fromJson(x))),
        misCentrosPoblados: List<MisCentroPoblados>.from(
            json["centrosPoblados"].map((x) => MisCentroPoblados.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "hasCredentials": hasCredentials,
        "iduser": iduser,
        "usuario": usuario,
        "usuarioAlias": usuarioAlias,
        "nombre": nombre,
        "apellido": apellido,
        "dni": dni,
        "perfil": perfil,
        "estado": estado,
        "token": token,
        "modules": List<dynamic>.from(modules.map((x) => x.toJson())),
        "centrosPoblados": List<dynamic>.from(modules.map((x) => x.toJson())),
      };
}

// To parse this JSON data, do
//
//     final responseUsuarioById = responseUsuarioByIdFromJson(jsonString);

List<ResponseUsuarioById> responseUsuarioByIdFromJson(String str) =>
    List<ResponseUsuarioById>.from(
        json.decode(str).map((x) => ResponseUsuarioById.fromJson(x)));

String responseUsuarioByIdToJson(List<ResponseUsuarioById> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ResponseUsuarioById {
  final int usuarioId;
  final String nombres;
  final dynamic usuario;
  final String apellidos;
  final String dni;
  final String usuarioAlias;
  final String correo;
  final String perfil;
  final String perfilesId;
  final dynamic estado;

  ResponseUsuarioById({
    required this.usuarioId,
    required this.nombres,
    this.usuario,
    required this.apellidos,
    required this.dni,
    required this.usuarioAlias,
    required this.correo,
    required this.perfil,
    required this.perfilesId,
    this.estado,
  });

  factory ResponseUsuarioById.fromJson(Map<String, dynamic> json) =>
      ResponseUsuarioById(
        usuarioId: json["usuario_id"],
        nombres: json["nombres"],
        usuario: json["usuario"],
        apellidos: json["apellidos"],
        dni: json["dni"],
        usuarioAlias: json["usuario_alias"],
        correo: json["correo"],
        perfil: json["perfil"],
        perfilesId: json["perfiles_id"],
        estado: json["estado"],
      );

  Map<String, dynamic> toJson() => {
        "usuario_id": usuarioId,
        "nombres": nombres,
        "usuario": usuario,
        "apellidos": apellidos,
        "dni": dni,
        "usuario_alias": usuarioAlias,
        "correo": correo,
        "perfil": perfil,
        "perfiles_id": perfilesId,
        "estado": estado,
      };
}
