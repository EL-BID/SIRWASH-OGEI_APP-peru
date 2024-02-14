class CentroPoblado {
  final int centroPobladosId;
  final String codigoCentroPoblados;
  final String nombre;
  final String alias;
  final String departamento;
  final String provincia;
  final String distrito;

  CentroPoblado({
    required this.centroPobladosId,
    required this.codigoCentroPoblados,
    required this.nombre,
    required this.alias,
    required this.departamento,
    required this.provincia,
    required this.distrito,
  });

  factory CentroPoblado.fromJson(Map<String, dynamic> json) => CentroPoblado(
        centroPobladosId: json["centro_poblados_id"],
        codigoCentroPoblados: json["codigo_centro_poblados"],
        nombre: json["nombre"],
        alias: json["alias"],
        departamento: json["departamento"],
        provincia: json["provincia"],
        distrito: json["distrito"],
      );

  factory CentroPoblado.fromSQLite(Map<String, dynamic> json) => CentroPoblado(
        centroPobladosId: json["CENTRO_POBLADOS_ID"],
        codigoCentroPoblados: json["CODIGO_CENTRO_POBLADOS"],
        nombre: json["NOMBRE"],
        alias: json["ALIAS"],
        departamento: json["DEPARTAMENTO"],
        provincia: json["PROVINCIA"],
        distrito: json["DISTRITO"],
      );

  Map<String, dynamic> toJson() => {
        "centro_poblados_id": centroPobladosId,
        "codigo_centro_poblados": codigoCentroPoblados,
        "nombre": nombre,
        "alias": alias,
        "departamento": departamento,
        "provincia": provincia,
        "distrito": distrito,
      };
}

// To parse this JSON data, do
//

class MisCentroPoblados {
  final int centroPobladosId;
  final String codigoCentroPoblados;
  final String alias;

  MisCentroPoblados({
    required this.centroPobladosId,
    required this.codigoCentroPoblados,
    required this.alias,
  });

  factory MisCentroPoblados.fromJson(Map<String, dynamic> json) =>
      MisCentroPoblados(
        centroPobladosId: json["centro_poblados_id"],
        codigoCentroPoblados: json["codigo_centro_poblados"],
        alias: json["alias"],
      );

  Map<String, dynamic> toJson() => {
        "centro_poblados_id": centroPobladosId,
        "codigo_centro_poblados": codigoCentroPoblados,
        "alias": alias,
      };
}
