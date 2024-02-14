import 'package:dio/dio.dart';
import 'package:get/instance_manager.dart';
import 'package:sirwash/data/models/login_response.dart';
import 'package:sirwash/data/models/models.dart';
import 'package:sirwash/data/models/user_credentials.dart';
import 'package:sirwash/utils/utils.dart';

class AuthProvider {
  final DioClient _dioClient = Get.find<DioClient>();

  /// Función inicial para validar las credenciales de un usuario
  Future<LoginResponse> loginWithEmail(String email, String password) async {
    final resp = await _dioClient.post('/seguridad', data: {
      'usuario': email,
      'clave': password,
    });
    return LoginResponse.fromJson(resp);
  }

  /// Recupera la contraseña de un usuario
  Future<bool> recoverPassword(String email) async {
    final resp = await _dioClient.post('/passrecovery', data: {'email': email});
    return resp['Error'] == null;
  }

  /// Solicita al backend los datos extras de un usuario mediante su [userId]
  Future<ResponseUsuarioById> getEmployeeByUserId(int userId,
      {Options? options}) async {
    final url = '/usuario?usuario_id=$userId';
    final resp = await _dioClient.get(url, options: options);

    return ResponseUsuarioById.fromJson(resp[0]);
  }

  /// Solicita al backend los módulos (encuestas) que un usuario podrá utilizar en la app
  Future<List<UserModule>> getModulesByUserId(int? userId,
      {Options? options}) async {
    final url = '/usuario/modulo/$userId';
    final resp = await _dioClient.get(url, options: options);

    return List<UserModule>.from(
      resp.map((e) => UserModule.fromJson(e)),
    );
  }

  /// Solicita al backend los centros poblados habilitador para este usuario
  ///
  /// En el caso de un usuario anónimo, se le habilitan todos los centros poblados
  Future<List<MisCentroPoblados>> getCentrosPobladosByUserId(int? userId,
      {Options? options}) async {
    final url = '/usuario/centrospoblados/$userId';
    final resp = await _dioClient.get(url, options: options);

    return List<MisCentroPoblados>.from(
      resp.map((e) => MisCentroPoblados.fromJson(e)),
    );
  }
}
