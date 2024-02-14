class Prestador {
  final int prestadoresId;
  final String codigo;
  final String nombre;
  final String codigoCentroPoblados;
  final String alias;

  Prestador({
    required this.prestadoresId,
    required this.codigo,
    required this.nombre,
    required this.codigoCentroPoblados,
    required this.alias,
  });

  factory Prestador.fromBackend(Map<String, dynamic> json) => Prestador(
        prestadoresId: json["prestadores_id"],
        codigo: json["codigo"],
        nombre: json["nombre"],
        codigoCentroPoblados: json["codigo_centro_poblados"],
        alias: json["alias"],
      );

  factory Prestador.fromSQLite(Map<String, dynamic> json) => Prestador(
        prestadoresId: json["PRESTADORES_ID"],
        codigo: json["CODIGO"],
        nombre: json["NOMBRE"],
        codigoCentroPoblados: json["CODIGO_CENTRO_POBLADOS"],
        alias: json["ALIAS"],
      );

  Map<String, dynamic> toSQLite() => {
        "PRESTADORES_ID": prestadoresId,
        "CODIGO": codigo,
        "NOMBRE": nombre,
        "CODIGO_CENTRO_POBLADOS": codigoCentroPoblados,
        "ALIAS": alias,
      };
}
