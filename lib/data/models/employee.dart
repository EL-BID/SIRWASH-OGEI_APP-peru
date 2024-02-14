// To parse this JSON data, do
//
//     final Employees = welcomeFromJson(jsonString);

import 'dart:convert';

List<Employees> welcomeFromJson(String str) => List<Employees>.from(json.decode(str).map((x) => Employees.fromJson(x)));

String welcomeToJson(List<Employees> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Employees {
    Employees({
        required this.idUser,
        required this.idEmployee,
        required this.name,
        required this.email,
        required this.enable,
        required this.employee,
    });

    int idUser;
    int idEmployee;
    String name;
    String email;
    bool enable;
    Employee employee;

    factory Employees.fromJson(Map<String, dynamic> json) => Employees(
        idUser: json["idUser"],
        idEmployee: json["idEmployee"],
        name: json["name"],
        email: json["email"],
        enable: json["enable"],
        employee: Employee.fromJson(json["employee"]),
    );

    Map<String, dynamic> toJson() => {
        "idUser": idUser,
        "idEmployee": idEmployee,
        "name": name,
        "email": email,
        "enable": enable,
        "employee": employee.toJson(),
    };
}

class Employee {
    Employee({
        required this.idEmployee,
        required this.idTypeDocument,
        required this.idRol,
        required this.numberDocument,
        required this.name,
        required this.lastname,
        required this.email,
        required this.cellPhone,
        required this.enable,
        required this.rol,
    });

    int idEmployee;
    int idTypeDocument;
    int idRol;
    String numberDocument;
    String name;
    String lastname;
    String email;
    String cellPhone;
    bool enable;
    Rol rol;

    factory Employee.fromJson(Map<String, dynamic> json) => Employee(
        idEmployee: json["idEmployee"],
        idTypeDocument: json["idTypeDocument"],
        idRol: json["idRol"],
        numberDocument: json["numberDocument"],
        name: json["name"],
        lastname: json["lastname"],
        email: json["email"],
        cellPhone: json["cellPhone"],
        enable: json["enable"],
        rol: Rol.fromJson(json["rol"]),
    );

    Map<String, dynamic> toJson() => {
        "idEmployee": idEmployee,
        "idTypeDocument": idTypeDocument,
        "idRol": idRol,
        "numberDocument": numberDocument,
        "name": name,
        "lastname": lastname,
        "email": email,
        "cellPhone": cellPhone,
        "enable": enable,
        "rol": rol.toJson(),
    };
}

class Rol {
    Rol({
        required this.idRol,
        required this.description,
        required this.enable,
    });

    int idRol;
    String description;
    bool enable;

    factory Rol.fromJson(Map<String, dynamic> json) => Rol(
        idRol: json["idRol"],
        description: json["description"],
        enable: json["enable"],
    );

    Map<String, dynamic> toJson() => {
        "idRol": idRol,
        "description": description,
        "enable": enable,
    };
}
