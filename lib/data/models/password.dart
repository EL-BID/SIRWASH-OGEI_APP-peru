// To parse this JSON data, do
//
//     final welcome = welcomeFromJson(jsonString);

import 'dart:convert';

UpdatePasswordResponse welcomeFromJson(String str) => UpdatePasswordResponse.fromJson(json.decode(str));

String welcomeToJson(UpdatePasswordResponse data) => json.encode(data.toJson());

class UpdatePasswordResponse {
    UpdatePasswordResponse({
        required this.success,
        required this.message,
        required this.result,
    });

    bool success;
    String message;
    String result;

    factory UpdatePasswordResponse.fromJson(Map<String, dynamic> json) => UpdatePasswordResponse(
        success: json["success"],
        message: json["message"],
        result: json["result"],
    );

    Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "result": result,
    };
}
