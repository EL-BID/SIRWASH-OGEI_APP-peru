// To parse this JSON data, do
//
//     final componente = componenteFromJson(jsonString);

class Componente {
  final int componentesId;
  final String nombre;
  final String alias;

  Componente({
    required this.componentesId,
    required this.nombre,
    required this.alias,
  });

  factory Componente.fromBackend(Map<String, dynamic> json) => Componente(
        componentesId: json["componentes_id"],
        nombre: json["nombre"],
        alias: json["alias"],
      );

  factory Componente.fromSQLite(Map<String, dynamic> json) => Componente(
        componentesId: json["COMPONENTES_ID"],
        nombre: json["NOMBRE"],
        alias: json["ALIAS"],
      );

  Map<String, dynamic> toSQLite() => {
        "COMPONENTES_ID": componentesId,
        "NOMBRE": nombre,
        "ALIAS": alias,
      };
}
