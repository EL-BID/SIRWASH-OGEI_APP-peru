import 'package:get/get.dart';
import 'package:sirwash/modules/datos/encuestas_saved/encuestas_saved_page.dart';
import 'package:sirwash/modules/encuestas/cloracion/cloracion_page.dart';
import 'package:sirwash/modules/encuestas/cloro_residual/cloro_residual_page.dart';
import 'package:sirwash/modules/encuestas/componente_sap/componente_sap_page.dart';
import 'package:sirwash/modules/encuestas/continuidad_servicio/continuidad_servicio_page.dart';
import 'package:sirwash/modules/intro/intro_page.dart';
import 'package:sirwash/modules/login/form/login_form_page.dart';
import 'package:sirwash/modules/login/lost_password/login_lost_password_page.dart';
import 'package:sirwash/modules/misc/error/misc_error_page.dart';
import 'package:sirwash/modules/misc/prueba/misc_prueba_page.dart';
import 'package:sirwash/modules/misc/prueba2/misc_prueba2_page.dart';
import 'package:sirwash/modules/photo_zoom/photo_zoom_page.dart';
import 'package:sirwash/modules/profile/view/profile_view_page.dart';
import 'package:sirwash/modules/splash/splash_page.dart';

import '../modules/home/home_page.dart';

part 'app_routes.dart';

class AppPages {
  static const initial = AppRoutes.SPLASH;
  static const _transition = Transition.cupertino;

  static final routes = [
    // LOGIN
    GetPage(
      name: AppRoutes.SPLASH,
      page: () => SplashPage(),
      transition: _transition,
    ),

    // LOGIN
    GetPage(
      name: AppRoutes.LOGIN_FORM,
      page: () => LoginFormPage(),
      transition: _transition,
    ),
    GetPage(
      name: AppRoutes.LOGIN_LOST_PASSWORD,
      page: () => LoginLostPasswordPage(),
      transition: _transition,
    ),

    // HOME
    GetPage(
      name: AppRoutes.HOME,
      page: () => const HomePage(),
      transition: _transition,
    ),

    // ENCUESTAS
    GetPage(
        name: AppRoutes.ENCUESTA_CLORO_RESIDUAL,
        page: () => EncuestaCloroResidualPage(),
        transition: _transition),
    GetPage(
        name: AppRoutes.ENCUESTA_CLORACION,
        page: () => EncuestaCloracionPage(),
        transition: _transition),
    GetPage(
        name: AppRoutes.ENCUESTA_COMPONENTE_SAP,
        page: () => EncuestaComponenteSapPage(),
        transition: _transition),
    GetPage(
        name: AppRoutes.ENCUESTA_CONTINUIDAD_SERVICIO,
        page: () => EncuestaContinuidadServicioPage(),
        transition: _transition),

    // DATOS
    GetPage(
        name: AppRoutes.DATOS_ENCUESTAS_SAVED,
        page: () => EncuestasSavedPage(),
        transition: _transition),

    // PROFILE
    GetPage(
      name: AppRoutes.PROFILE_VIEW,
      page: () => ProfileViewPage(),
      transition: _transition,
    ),

    // MISC
    GetPage(
        name: AppRoutes.MISC_ERROR,
        page: () => MiscErrorPage(),
        transition: _transition),
    GetPage(
        name: AppRoutes.MISC_PRUEBA,
        page: () => MiscPruebaPage(),
        transition: _transition),
    GetPage(
        name: AppRoutes.MISC_PRUEBA_2,
        page: () => const MiscPrueba2Page(),
        transition: _transition),

    //INTRO
    GetPage(
        name: AppRoutes.INTRO_PAGES,
        page: () => IntroPage(),
        transition: _transition),

    // PHOTO ZOOM
    GetPage(
        name: AppRoutes.PHOTO_ZOOM,
        page: () => PhotoZoomPage(),
        transition: _transition),
  ];
}
