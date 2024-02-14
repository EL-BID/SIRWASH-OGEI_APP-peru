// ignore_for_file: constant_identifier_names

part of 'app_pages.dart';

abstract class AppRoutes {
  // SPLASH
  static const SPLASH = '/splash';

  // LOGIN
  static const LOGIN_FORM = '/login_form';
  static const LOGIN_LOST_PASSWORD = '/login_lost_password';

  // HOME
  static const HOME = '/home';

  // ENCUESTA
  static const ENCUESTA_CLORO_RESIDUAL = '/encuestas/cloro_residual';
  static const ENCUESTA_CLORACION = '/encuestas/cloracion';
  static const ENCUESTA_COMPONENTE_SAP = '/encuestas/componente_sap';
  static const ENCUESTA_CONTINUIDAD_SERVICIO =
      '/encuestas/continuidad_servicio';

  // DATOS
  static const DATOS_ENCUESTAS_SAVED = '/datos/encuestas_saved';

  // PROFILE
  static const PROFILE_VIEW = '/profile_view';

  // MISC
  static const MISC_ERROR = '/misc_error';
  static const MISC_PRUEBA = '/prueba';
  static const MISC_PRUEBA_2 = '/prueba_2';

  // INTRO PAGES
  static const INTRO_PAGES = '/intro';

  // PHOTO ZOOM
  static const PHOTO_ZOOM = '/photo_zoom';
}
