import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:sirwash/config/config.dart';
import 'package:sirwash/data/providers/db_provider.dart';
import 'package:sirwash/modules/auth/auth_controller.dart';
import 'package:sirwash/modules/global_settings/global_settings_controller.dart';
import 'package:sirwash/modules/prefs/prefs_controller.dart';
import 'package:sirwash/utils/utils.dart';
import 'package:sirwash/widgets/widgets.dart';

class InstanceBinding extends Bindings {
  @override
  Future<void> dependencies() async {
    Get.put(PrefsController());
    Get.put(AuthController());

    Get.put(GlobalSettingsController());

    final Dio dio = Dio();

    // Inyección del cliente para peticiones http
    Get.put(DioClient(
      Config.URL_API,
      dio,
      interceptors: [AppInterceptors()],
    ));

    await DBProvider.db.ping();
  }
}

// Clase utilizada para agregar el token a las peticiones
class AppInterceptors extends InterceptorsWrapper {
  final _authX = Get.find<AuthController>();
  @override
  Future onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    // Cuando se ingresó con usuario y contraseña, se adjunta el token
    if (_authX.userCredentials != null) {
      options.headers["Authorization"] = _authX.userCredentials!.token;
    }
    return super.onRequest(options, handler);
  }

  @override
  onResponse(dynamic response, ResponseInterceptorHandler handler) {
    return super.onResponse(response, handler);
  }

  @override
  onError(DioError err, ErrorInterceptorHandler handler) {
    // Cuando la sesión expira, la app redirige al login
    if (err.response?.statusCode == 401) {
      AppSnackbar()
          .error(message: 'Sesión caducada!\nInicie sesión nuevamente');
      _authX.logout();
    } else {
      super.onError(err, handler);
    }
  }
}
