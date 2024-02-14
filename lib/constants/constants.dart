// ignore_for_file: constant_identifier_names

import 'package:sirwash/data/models/tipo_encuesta.dart';
import 'package:sirwash/utils/utils.dart';

const K_BOX_USERSESSION_KEY = 'user_session';

const K_OFFLINE_MAP_NAME = 'peru.map';

/// Lista de encuestas habilitadas para ser mostradas
/// a lo largo de toda la aplicación.
///
/// El campo [keycode] debe ser exactamente igual a como
/// está definido en el backend.
const List<TipoEncuesta> encuestasApp = [
  TipoEncuesta(
    key: EncuestaKey.cloroResidual,
    titulo: "Medición de Cloro Residual",
    subTitulo: "",
    imgPath: "assets/img/medicion.png",
    keycode: "FORM_MEDICION",
  ),
  TipoEncuesta(
    key: EncuestaKey.componenteSap,
    titulo: "Limpieza y Desinfección de componentes del SAP",
    subTitulo: "",
    imgPath: "assets/img/limpieza.png",
    keycode: "FORM_LIMPIEZA",
  ),
  TipoEncuesta(
    key: EncuestaKey.continuidadServicio,
    titulo: "Continuidad de Servicio",
    subTitulo: "",
    imgPath: "assets/img/continuidad.png",
    keycode: "FORM_CONTINUIDAD",
  ),
  TipoEncuesta(
    key: EncuestaKey.cloracion,
    titulo: "Cloración",
    subTitulo: "",
    imgPath: "assets/img/potabilizacion.png",
    keycode: "FORM_CLORACION",
  ),
];

/// Retorna el títutlo de una encuesta en base al enum de EncuestaKey
/// Se ha definido así para aprovechar el linter de Dart.
String getTituloTipoEncuesta(EncuestaKey key) {
  final tipoEncuesta = encuestasApp.firstWhereOrNull((e) => e.key == key);

  return tipoEncuesta?.titulo ?? '';
}
