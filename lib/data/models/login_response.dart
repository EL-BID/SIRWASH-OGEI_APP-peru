// To parse this JSON data, do
//
//     final loginResponse = loginResponseFromJson(jsonString);

import 'dart:convert';

LoginResponse loginResponseFromJson(String str) =>
    LoginResponse.fromJson(json.decode(str));

String loginResponseToJson(LoginResponse data) => json.encode(data.toJson());

class LoginResponse {
  final bool success;
  final int code;
  final String result;
  // Es nulllable, porque cuando las credenciales son incorrectas este campo no es enviado.
  // Mantener como nullable
  final int? iduser;
  final String? message;

  LoginResponse({
    required this.success,
    required this.code,
    required this.result,
    this.iduser,
    this.message,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) => LoginResponse(
        success: json["success"],
        code: json["code"],
        result: json["result"],
        iduser: json["iduser"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "code": code,
        "result": result,
        "iduser": iduser,
        "message": message,
      };
}
